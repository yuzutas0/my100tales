# tale_repository
class TaleRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(user_id: nil, tags: nil, scores: nil, sort: nil, page: nil)
    Tale.index_by_db(user_id, tags, scores, sort, page)
  end

  # search by MariaDB
  def self.search_by_db(user_id: nil, keywords: nil, tags: nil, scores: nil, sort: nil, page: nil)
    Tale.search_by_db(user_id, keywords, tags, scores, sort, page)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id: nil, keywords: nil, tags: nil, scores: nil, sort: nil, page: nil)
    Tale.search_by_es(user_id, keywords, tags, scores, sort, page)
  end

  # get all records
  def self.all(user_id)
    Tale.where(user_id: user_id)
        .includes(:sequels, :tags, :scores)
        .merge(Sequel.order('sequels.view_number DESC'))
        .merge(Tag.order('tags.view_number DESC'))
        .merge(Score.order('scores.view_number DESC'))
  end

  # count records
  def self.count(user_id)
    Tale.where(user_id: user_id).count
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
        .includes(:scores)
        .includes(:sequels)
        .first
  end
end
