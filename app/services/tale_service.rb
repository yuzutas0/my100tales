# tale_service
class TaleService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, user)
    Tale.transaction do
      tale = TaleFactory.instance(params, user)
      tale if tale.save
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------
  def self.list(user_id, queries)
    # without keyword
    return TaleRepository.list(user_id, queries.page) if queries.keyword.blank?
    # with keyword
    begin
      # Elasticsearch
      TaleRepository.search_by_es(
        user_id,
        queries.keyword.html_safe,
        queries.page
      )
    rescue
      # mariaDB
      TaleRepository.search_by_db(
        user_id,
        queries.keyword.html_safe,
        queries.page
      )
    end
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------
  def self.detail(view_number, user_id)
    TaleRepository.detail(view_number, user_id)
  end
end
