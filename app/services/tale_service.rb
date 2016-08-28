# tale_service
class TaleService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, option_form, user)
    Tale.transaction do
      tale = TaleFactory.instance(params, user)
      success = tale.save
      change_tags(tale, option_form, user)
      return tale, success
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
    rescue => e
      logger.warn "failure to request Elasticsearch: #{e.message}"
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

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def self.update(tale, tale_params, option_form, user)
    Tale.transaction do
      success = tale.update(tale_params)
      change_tags(tale, option_form, user)
      return tale, success
    end
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  private

  # *** use transaction ***
  # change tags and relation between tale and tags
  # FIXME: performance turning
  def self.change_tags(tale, option_form, user)
    new_tag_list = TagService.create_and_read(user, option_form.tags)
    TaleTagRelationshipService.change(tale, new_tag_list)
  end
end
