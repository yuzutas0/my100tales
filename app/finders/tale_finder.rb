# tale_finder
module TaleFinder
  extend ActiveSupport::Concern

  # methods
  module ClassMethods
    # search
    # FIXME: kaminari, analyzer
    def search_index(user_id, keyword)
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
