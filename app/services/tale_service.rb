# tale_service
class TaleService

  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, user)
    Tale.transaction do
      tale = TaleFactory.instance(params, user)
      if tale.save
        tale
      else
        nil
      end
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------
  def self.list(user_id, queries)
    # without keyword
    if queries.keyword.blank?
      return TaleRepository.list(user_id, queries.page)
    end
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
