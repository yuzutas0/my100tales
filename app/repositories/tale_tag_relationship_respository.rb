# tale_tag_relationship_repository
class TaleTagRelationshipRepository
  # -----------------------------------------------------------------
  # Select
  # -----------------------------------------------------------------

  # SELECT * FROM tale_tag_relationship
  # WHERE tale_id = #{tale_id} AND tag_id IN ( #{tag_id_list[0]}, ..., #{tag_id_list[n]} )
  def self.list_by_tale_and_tag_list(tale_id, tag_id_list)
    TaleTagRelationship.where('tale_id = ? AND tag_id IN (?)', tale_id, tag_id_list)
  end

  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # DELETE FROM tale_tag_relationship
  # WHERE id IN ( #{relation_id_list[0]}, ..., #{relation_id_list[n]} )
  def self.delete_by_id_list(relation_id_list)
    TaleTagRelationshipRepository.delete_all('id IN (?)', relation_id_list)
  end
end
