# sequel_service
class SequelService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, tale_view_number, user_id)
    Sequel.transaction do
      tale = TaleRepository.detail(tale_view_number, user_id)
      sequel = SequelFactory.instance(params, tale)
      success = sequel.save
      return tale, sequel, success
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  def self.list(tale_id)
    sequels = SequelRepository.list(tale_id)
    new_sequel = Sequel.new
    return sequels, new_sequel
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(user_id, tale_view_number, sequel_view_number)
    TaleRepository.detail(tale_view_number, user_id)
                  .sequels
                  .find_by(view_number: sequel_view_number)
  end
end
