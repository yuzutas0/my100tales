# search_condition_repository
class SearchConditionRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.select_by_user(user_id)
    SearchCondition.where(user_id: user_id).order(updated_at: :desc)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def update_time(search_condition)
    search_condition.updated_at = Time.now
    search_condition.update
  end
end
