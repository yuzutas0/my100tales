# tale_tag_relationship_repository
class TaleTagRelationshipRepository
  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # DELETE FROM tale_tag_relationships WHERE tale_id = #{tale_id}
  def self.delete_by_tale_id(tale_id)
    TaleTagRelationship.where('tale_id = ?', tale_id).delete_all
  end
end
