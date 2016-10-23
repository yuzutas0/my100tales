# score_service
class ScoreService
  # -----------------------------------------------------------------
  # Create, Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # change scores and relation between tale and scores
  def self.change_scores(tale_id, scores, user)
    # ScoreFactory.create_only_new_name(user, scores)
    # TaleScoreRelationshipService.update(tale_id, scores)
  end
end
