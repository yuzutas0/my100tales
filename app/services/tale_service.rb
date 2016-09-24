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

  # return [is_searched, tales, tags, tags_attached]
  #
  # *** attention ***
  # combine tales.tale_tag_relationships with tag as necessary!
  # e.g. (tags.select { |tag| tag.id == relation.tag_id })[0].name
  # because avoid to throw query about tag records twice
  def self.list(user_id, queries)
    # get data for tale index
    is_searched = queries.keyword.present?
    tales = is_searched ?
        search(user_id, queries) :
        TaleRepository.list(user_id, queries.tags, queries.sort, queries.page)

    tale_id_list = tales.inject([]) { |array, tale| array << tale.id }
    sequels_attached = SequelRepository.tale_id_and_attached_count(tale_id_list)

    # get data for search form
    tags = TagRepository.list(user_id)
    tags_attached = TagRepository.view_number_and_attached_count(user_id)

    # response
    [is_searched, tales, tags, tags_attached, sequels_attached]
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

    # get list with keyword
    def search(user_id, queries)
      TaleRepository.search_by_es(search_args(user_id, queries))
    rescue => e
      Rails.logger.warn "failure to request Elasticsearch: #{e.message}"
      TaleRepository.search_by_db(search_args(user_id, queries))
    end

    def search_args(user_id, queries)
      {
          user_id: user_id,
          keyword: queries.keyword.split(/[[:blank:]]+/).reject(&:blank?).uniq,
          tags: queries.tags,
          sort: queries.sort,
          page: queries.page
      }
    end
  end
end
