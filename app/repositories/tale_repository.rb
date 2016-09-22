# tale_repository
class TaleRepository
  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  RECORD_LIST_LIMIT_SIZE = 10.freeze

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(user_id, page)
    condition = Tale.where('user_id = ?', user_id)
    read_index(condition, page)
  end

  # search by MariaDB
  def self.search_by_db(user_id, keyword, page)
    keyword = '%' + keyword + '%'
    condition = Tale.where('user_id = ? AND (title LIKE ? OR content LIKE ?)', user_id, keyword, keyword)
    read_index(condition, page)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id, keyword, page)
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
          .page(page)
          .per(RECORD_LIST_LIMIT_SIZE)
          .order(created_at: :desc)
          .includes(:tale_tag_relationships)
    end
  end
end
