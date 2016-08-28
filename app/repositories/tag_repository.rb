# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Select
  # -----------------------------------------------------------------

  # SELECT * FROM tags WHERE user_id = [user_id] AND name IN ( #{name_list[0]}, ..., #{name_list[n]} )
  def self.list_by_name_list(user_id, name_list)
    Tag.where('user_id = ? AND name IN (?)', user_id, name_list)
  end

  # SELECT DISTINCT(*) FROM tags
  # INNER JOIN tale_tag_relationships ON tags.id = tale_tag_relationships.tag_id
  # WHERE tale_tag_relationships.tale_id = #{tale_id}
  def self.list_by_tale(tale_id)
    Tag.joins(:tale_tag_relationships)
       .where('tale_tag_relationships.tale_id = ?', tale_id)
       .uniq
  end
end
