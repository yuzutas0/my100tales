# tale_service
class TaleService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # render page for create
  def self.new
    tale = Tale.new
    tale.tags = []
    tale
  end

  # action to create
  def self.create(params, option_form, user)
    Tale.transaction do
      tale = TaleFactory.instance(params, user)
      success = tale.save
      change_tags(tale.id, option_form, user)
      return tale, success
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # return [is_searched, tales]
  def self.list(user_id, queries)
    queries.keyword.blank? ?
        list_without_keyword(user_id, queries) :
        list_with_keyword(user_id, queries)
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------
  def self.detail(view_number, user_id)
    TaleRepository.detail(view_number, user_id)
  end

  def self.detail_with_options(view_number, user_id)
    TaleRepository.detail_with_options(view_number, user_id)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def self.update(tale, tale_params, option_form, user)
    Tale.transaction do
      success = tale.update(tale_params)
      change_tags(tale.id, option_form, user)
      return tale, success
    end
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # *** use transaction ***
    # change tags and relation between tale and tags
    def change_tags(tale_id, option_form, user)
      TagFactory.create_only_new_name(user, option_form.tags)
      TaleTagRelationshipService.update(tale_id, option_form.tags)
    end

    # get list without keyword
    # return [is_searched, tales]
    def list_without_keyword(user_id, queries)
      tales = TaleRepository.list(user_id, queries.page)
      [false, tales]
    end

    # get list with keyword
    # return [is_searched, tales]
    def list_with_keyword(user_id, queries)
      begin
        tales = search_by_es(user_id, queries)
      rescue => e
        logger.warn "failure to request Elasticsearch: #{e.message}"
        tales = search_by_db(user_id, queries)
      end
      [true, tales]
    end

    # search by Elasticsearch
    def search_by_es(user_id, queries)
      TaleRepository.search_by_es(
        user_id,
        queries.keyword.html_safe,
        queries.page
      )
    end

    # search by mariaDB
    def search_by_db(user_id, queries)
      TaleRepository.search_by_db(
        user_id,
        queries.keyword.html_safe,
        queries.page
      )
    end
  end
end
