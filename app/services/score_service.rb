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
  # Update
  # -----------------------------------------------------------------

  # called by ScoresController#update
  # one request can update only one column, whether key or value
  def self.update(score, params, user_id)
    key = params[:key_name]
    return ScoreRepository.update_key(score, key, user_id) if score.key_name != key
    ScoreRepository.update(score, params)
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # called by TalesController#index
  # [scores, scores_attached]
  def self.list(user_id)
    scores = ScoreRepository.list(user_id)
    scores_attached = ScoreRepository.view_number_and_attached_count(user_id)
    [scores, scores_attached]
  end

  # called by ScoresController#set_score to throw query about score
  def self.detail(user_id, view_number)
    ScoreRepository.detail(user_id, view_number)
  end

  # called by TaleController#ready_form to show suggestion
  def self.key_and_attached_count(user_id)
    ScoreRepository.key_and_attached_count(user_id)
  end

  # called by SearchForm#sort_master
  def self.sort_master(user_id)
    master = []
    ScoreRepository.key_names(user_id).each do |key|
      [:desc, :asc].each { |value| master << { key => value } }
    end
    master
  end

  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # called by ScoresController#destroy_by_key
  def self.delete_by_key(user_id, key)
    Score.transaction do
      TaleScoreRelationshipRepository.delete_by_score_key(user_id, key)
      ScoreRepository.delete_by_key(user_id, key)
    end
  end
end
