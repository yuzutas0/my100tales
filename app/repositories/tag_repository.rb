# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.list(user_id)
    Tag.where('user_id = ?', user_id)
  end

  def self.name_list(user_id)
    Tag.where('user_id = ?', user_id).pluck(:name)
  end

  def self.detail(user_id, view_number)
    Tag.where('user_id = ? AND view_number = ?', user_id, view_number).first
  end
end
