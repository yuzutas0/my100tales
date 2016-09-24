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
    def index_by_db(user_id, tags, sort, page)
      condition = condition_for_db(user_id, tags)
      read(condition, sort, page)
    end

    # called by TaleRepository#search_by_db
    def search_by_db(user_id, keywords, tags, sort, page)
      condition = condition_for_db(user_id, tags)
      keywords.each do |keyword|
        keyword = '%' + keyword + '%'
        condition = condition.where(QUERY[:keyword], keyword, keyword)
      end
      read(condition, sort, page)
    end

    # called by TaleRepository#search_by_es
    def search_by_es(user_id, keywords, tags, sort, page)
      # FIXME through waste query by Elasticsearch::Model::Response::Records
      condition = if tags.present?
                    search_request(user_id, keywords).records
                        .joins(:tale_tag_relationships)
                        .where(QUERY[:tags], tags)
                  else
                    search_request(user_id, keywords).records
                  end
      read(condition, sort, page)
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

    # common logic
    def read(condition, sort, page)
      condition
          .uniq
          .page(page)
          .per(DB_LIMIT_SIZE)
          .order(custom_sort(sort))
          .includes(:tale_tag_relationships)
    end

    # refs. SearchForm#sort_master
    def custom_sort(sort)
      case sort
        when 1 then { created_at: :asc }
        when 2 then { updated_at: :desc }
        when 3 then { updated_at: :asc }
        else { created_at: :desc }
      end
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
