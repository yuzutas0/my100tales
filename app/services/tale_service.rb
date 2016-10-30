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
      change_records(tale, option_form, user, success)
      return tale, success
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # return tale list
  def self.list(user_id, queries)
    tales = search(user_id, queries)
    sequels_attached = sequels_attached(tales)
    [tales, sequels_attached]
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
      change_records(tale, option_form, user, success)
      return tale, success
    end
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # -----------------------------------------------------------------
    # Create, Update
    # -----------------------------------------------------------------
    def change_records(tale, option_form, user, success)
      return unless success
      TagService.change_tags(tale.id, option_form.tags, user)
      ScoreService.change_scores(tale.id, option_form.scores, user)
    end

    # -----------------------------------------------------------------
    # Read
    # -----------------------------------------------------------------

    # get list with keyword
    def search(user_id, queries)
      return TaleRepository.list(search_args_without_keyword(user_id, queries)) if queries.keyword.blank?
      TaleRepository.search_by_es(search_args_with_keyword(user_id, queries))
    rescue => e
      Rails.logger.warn "failure to request Elasticsearch: #{e.message}"
      TaleRepository.search_by_db(search_args_with_keyword(user_id, queries))
    end

    def search_args_without_keyword(user_id, queries)
      {
        user_id: user_id,
        tags: queries.tags,
        scores: queries.scores,
        sort: queries.sort,
        page: queries.page
      }
    end

    def search_args_with_keyword(user_id, queries)
      hash = search_args_without_keyword(user_id, queries)
      hash.merge({ keywords: queries.keyword.split(/[[:blank:]]+/).reject(&:blank?).uniq })
    end

    def sequels_attached(tales)
      tale_id_list = tales.map(&:id)
      SequelRepository.tale_id_and_attached_count(tale_id_list)
    end
  end
end
