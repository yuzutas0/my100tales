# tale_score_relationship_repository
class TaleScoreRelationshipRepository
  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # DELETE FROM tale_score_relationships WHERE tale_id = #{tale_id}
  def self.delete_by_tale_id(tale_id)
    TaleScoreRelationship.where('tale_id = ?', tale_id).delete_all
  end

  # DELETE FROM tale_score_relationships
  # INNER JOIN score
  # WHERE score.user_id = #{user_id} AND score.key_name = #{key}
  def self.delete_by_score_key(user_id, key)
    return if key.blank?
    TaleScoreRelationship
        .joins(:score)
        .merge(Score.where('user_id = ? AND key_name = ?', user_id, key))
        .delete_all
  end
end
