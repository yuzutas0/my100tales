# tag_service
class TagService
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------
  def self.list(user_id)
    TagRepository.list(user_id) || []
  end

  def self.name_list(user_id)
    TagRepository.name_list(user_id) || []
  end
end
