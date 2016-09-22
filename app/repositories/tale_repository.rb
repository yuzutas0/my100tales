# tale_repository
class TaleRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # const
  READ_INDEX_LIMIT_SIZE = 10.freeze
  READ_INDEX_QUERY = {
      user: 'tales.user_id = ?',
      tags: 'tale_tag_relationships.tag_id IN (?)',
      keyword: '(tales.title LIKE ? OR tales.content LIKE ?)',
      and: ' AND '
  }.freeze

  # get index by MariaDB
  def self.list(user_id, tags, page)
    query = READ_INDEX_QUERY[:user]
    condition = if tags.present?
                  query = query + READ_INDEX_QUERY[:and] + READ_INDEX_QUERY[:tags]
                  Tale.joins(:tale_tag_relationships)
                      .where(query, user_id, tags)
                else
                  Tale.where(query, user_id)
                end
    read_index(condition, page)
  end

  # search by MariaDB
  def self.search_by_db(user_id, keyword, tags, page)
    keyword = '%' + keyword + '%'
    query = READ_INDEX_QUERY[:user] + READ_INDEX_QUERY[:and] + READ_INDEX_QUERY[:keyword]
    condition = if tags.present?
                  query = query + READ_INDEX_QUERY[:and] + READ_INDEX_QUERY[:tags]
                  Tale.joins(:tale_tag_relationships)
                      .where(query, user_id, keyword, keyword, tags)
                else
                  Tale.where(query, user_id, keyword, keyword)
                end
    read_index(condition, page)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id, keyword, tags, page)
    condition = Tale.search_index(user_id, keyword).records
    read_index(condition, page)
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  # without options
  def self.detail(view_number, user_id)
    Tale.where('view_number = ? AND user_id = ?', view_number, user_id)
        .first
  end

  # with options
  def self.detail_with_options(view_number, user_id)
    Tale.where('view_number = ? AND user_id = ?', view_number, user_id)
        .includes(:tags)
        .includes(:sequels)
        .first
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private
    # common logic for Read - index
    def read_index(condition, page)
      condition
          .uniq
          .page(page)
          .per(READ_INDEX_LIMIT_SIZE)
          .order(created_at: :desc)
          .includes(:tale_tag_relationships)
    end
  end
end
