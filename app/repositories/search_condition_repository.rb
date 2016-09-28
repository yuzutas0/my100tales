# search_condition_repository
class SearchConditionRepository
  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  RECORD_SIZE = 5

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.select_by_user(user_id)
    SearchCondition.where(user_id: user_id).order(updated_at: :desc)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def self.update_time(search_condition)
    search_condition.updated_at = Time.now
    search_condition.update
  end

  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------
  # the records count = 5 after this query
  def self.delete_to_size(user_id, save_flag, present_size)
    # validate
    delete_size = present_size - RECORD_SIZE
    return unless delete_size > 0
    # query
    query = <<-'SQL'.freeze
      DELETE
      FROM
        search_conditions S
      WHERE
        S.user_id = ?
        AND S.save_flag = ?
      ORDER BY
        S.updated_at ASC
      LIMIT
        ?
    SQL
    # execute
    args = [query, user_id, save_flag, delete_size]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end
