# tale_tag_relationship_service
class TaleTagRelationshipService
  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # update records by delete old relation and create new relation
  def self.update(tale_id, tag_name_list)
    TaleTagRelationshipRepository.delete_by_tale_id(tale_id)
    TaleTagRelationshipFactory.create_by_tag_name_list(tale_id, tag_name_list)
  end
end
