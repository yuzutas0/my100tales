# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------
  def self.name_list(user_id)
    Tag.where('user_id = ?', user_id).pluck(:name)
  end
end
