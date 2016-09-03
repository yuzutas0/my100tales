# tag_service
class TagService
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.list(user_id)
    TagRepository.list(user_id) || []
  end

  def self.name_list(user_id)
    TagRepository.name_list(user_id) || []
  end

  def self.detail(user_id, view_number)
    TagRepository.detail(user_id, view_number)
  end
end
