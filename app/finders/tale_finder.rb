# tale_finder
module TaleFinder
  extend ActiveSupport::Concern

  # methods
  module ClassMethods
    # search
    # FIXME: kaminari, analyzer
    def search_index(user_id, query)
      __elasticsearch__.search(
        query: {
          bool: {
            should: [
              { term: { title: query.downcase } },
              { term: { content: query.downcase } }
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
