# tale_score_relationship_service
class TaleScoreRelationshipService
  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # update records by delete old relation and create new relation
  def self.update(tale_id, score_hash_list)
    TaleScoreRelationshipRepository.delete_by_tale_id(tale_id)
    TaleScoreRelationshipFactory.create_by_score_hash_list(tale_id, score_hash_list)
  end
end
