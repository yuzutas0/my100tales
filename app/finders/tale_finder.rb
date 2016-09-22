# tale_finder
module TaleFinder
  extend ActiveSupport::Concern

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  LIMIT_SIZE = 10.freeze
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
      query = QUERY[:user]
      condition = if tags.present?
                    query = query + QUERY[:and] + QUERY[:tags]
                    Tale.joins(:tale_tag_relationships)
                        .where(query, user_id, tags)
                  else
                    Tale.where(query, user_id)
                  end
      read(condition, page)
    end

    # called by TaleRepository#search_by_db
    def search_by_db(user_id, keyword, tags, page)
      keyword = '%' + keyword + '%'
      query = QUERY[:user] + QUERY[:and] + QUERY[:keyword]
      condition = if tags.present?
                    query = query + QUERY[:and] + QUERY[:tags]
                    Tale.joins(:tale_tag_relationships)
                        .where(query, user_id, keyword, keyword, tags)
                  else
                    Tale.where(query, user_id, keyword, keyword)
                  end
      read(condition, page)
    end

    # called by TaleRepository#search_by_es
    def search_by_es(user_id, keyword, tags, page)
      condition = search_request(user_id, keyword).records
      read(condition, page)
    end

    # -----------------------------------------------------------------
    # Support
    # -----------------------------------------------------------------
    private

    # common logic
    def read(condition, page)
      condition
          .uniq
          .page(page)
          .per(LIMIT_SIZE)
          .order(created_at: :desc)
          .includes(:tale_tag_relationships)
    end

    # keyword search by elasticsearch
    # FIXME: kaminari, analyzer
    def search_request(user_id, keyword)
      __elasticsearch__.search(
          query: {
              bool: {
                  should: [
                      { term: { title: keyword.downcase } },
                      { term: { content: keyword.downcase } }
                  ]
              }
          },
          filter: {
              term: { user_id: user_id }
          },
          sort: [
              { created_at: { order: 'desc' } }
          ],
          size: 10_000
      )
    end
  end
end
