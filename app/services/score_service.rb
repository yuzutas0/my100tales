# score_service
class ScoreService
  # -----------------------------------------------------------------
  # Create, Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # change scores and relation between tale and scores
  def self.change_scores(tale_id, scores, user)
    ScoreFactory.create_only_new_name(user, scores)
    TaleScoreRelationshipService.update(tale_id, scores)
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # called TalesController#index
  # [scores, scores_attached]
  def self.list(user_id)
    scores = ScoreRepository.list(user_id)
    scores_attached = ScoreRepository.view_number_and_attached_count(user_id)
    [scores, scores_attached]
  end

  # called by TaleController#ready_form to show suggestion
  def self.key_and_attached_count(user_id)
    ScoreRepository.key_and_attached_count(user_id)
  end
end
