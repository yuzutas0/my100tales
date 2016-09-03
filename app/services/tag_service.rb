# tag_service
class TagService
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------
  def self.name_list(user_id)
    TagRepository.name_list(user_id)
  end
end
