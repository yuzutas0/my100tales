# tale_repository
class TaleRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(user_id, tags, page)
    Tale.index_by_db(user_id, tags, page)
  end

  # search by MariaDB
  def self.search_by_db(user_id, keyword, tags, page)
    Tale.search_by_db(user_id, keyword, tags, page)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id, keyword, tags, page)
    Tale.search_by_es(user_id, keyword, tags, page)
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
end
