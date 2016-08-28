# tale_tag_relationship_service
class TaleTagRelationshipService
  # -----------------------------------------------------------------
  # Change
  # -----------------------------------------------------------------

  # *** use transaction ***
  # create only new relation, delete only old relation, change no record about common relation
  def self.change(tale, new_tag_list)
    old_tag_list = TagRepository.list_by_tale(tale.id)
    TaleTagRelationshipFactory.create_only_new_relation(tale, new_tag_list - old_tag_list)
    delete_only_old_relation(old_tag_list - new_tag_list)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  private

  # delete only old relations for the user
  def self.delete_only_old_relation(only_old_tag_list)
    return if only_old_tag_list.blank?
    TaleTagRelationshipRepository.delete_by_id_list(only_old_tag_list)
  end
end
