# tale_finder
module TaleFinder
  extend ActiveSupport::Concern

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DB_LIMIT_SIZE = 10.freeze
  ES_LIMIT_SIZE = 10_000.freeze
  QUERY = {
      user: 'tales.user_id = ?',
      tags: 'tale_tag_relationships.tag_id IN (?)',
      keyword: '(tales.title LIKE ? OR tales.content LIKE ?)',
      and: ' AND '
  }.freeze

  # -----------------------------------------------------------------
  # Methods
  # -----------------------------------------------------------------
  module ClassMethods

    # called by TaleRepository#list
    def index_by_db(user_id, tags, page)
      condition = condition_for_db(user_id, tags)
      read(condition, page)
    end

    # called by TaleRepository#search_by_db
    def search_by_db(user_id, keywords, tags, page)
      condition = condition_for_db(user_id, tags)
      keywords.each do |keyword|
        keyword = '%' + keyword + '%'
        condition = condition.where(QUERY[:keyword], keyword, keyword)
      end
      read(condition, page)
    end

    # called by TaleRepository#search_by_es
    def search_by_es(user_id, keywords, tags, page)
      # FIXME through waste query by Elasticsearch::Model::Response::Records
      condition = if tags.present?
                    search_request(user_id, keywords).records
                        .joins(:tale_tag_relationships)
                        .where(QUERY[:tags], tags)
                  else
                    search_request(user_id, keywords).records
                  end
      read(condition, page)
    end

    # -----------------------------------------------------------------
    # Support
    # -----------------------------------------------------------------
    private

    # common logic
    def condition_for_db(user_id, tags)
      if tags.present?
        Tale.joins(:tale_tag_relationships)
            .where(QUERY[:user] + QUERY[:and] + QUERY[:tags], user_id, tags)
      else
        Tale.where(QUERY[:user], user_id)
      end
    end

    def read(condition, page)
      condition
          .uniq
          .page(page)
          .per(DB_LIMIT_SIZE)
          .order(created_at: :desc)
          .includes(:tale_tag_relationships)
    end

    # keyword search by elasticsearch
    # FIXME: kaminari, analyzer, has_child
    def search_request(user_id, keywords)

      keyword_queries = keywords.map do |keyword|
        {
            bool: {
                should: [
                    { term: { title: keyword.downcase } },
                    { term: { content: keyword.downcase } }
                ]
            }
        }
      end

      __elasticsearch__.search(
          query: {
              bool: {
                  must: keyword_queries
              }
          },
          filter: {
              term: {
                  user_id: user_id
              }
          },
          sort: [
              {
                  created_at: {
                      order: 'desc'
                  }
              }
          ],
          size: ES_LIMIT_SIZE
      )
    end
  end
end
