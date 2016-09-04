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

  # get hash about tag's view_number and how many tales tag is attached to
  # => { view_number: size, ... }
  # e.g. { 1: 21, 2: 15, 3: 23 }
  def self.attached_count(user_id)
    TagRepository.attached_count(user_id).to_h || {}
  end
end
