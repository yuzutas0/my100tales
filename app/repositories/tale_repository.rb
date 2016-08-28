# tale_repository
class TaleRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(user_id, page)
    Tale.includes(:tags)
        .where('user_id = ?', user_id)
        .page(page)
        .per(10)
        .order(created_at: :desc)
  end

  # search by MariaDB
  def self.search_by_db(user_id, keyword, page)
    keyword = '%' + keyword + '%'
    Tale.includes(:tags)
        .where('user_id = ? AND (title LIKE ? OR content LIKE ?)', user_id, keyword, keyword)
        .page(page)
        .per(10)
        .order(created_at: :desc)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id, query, page)
    Tale.includes(:tags)
        .search_index(user_id, query)
        .records
        .page(page)
        .per(10)
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
    Tale.includes(:tags)
        .where('view_number = ? AND user_id = ?', view_number, user_id)
        .first
  end
end
