# common_repository
class CommonRepository
  # -----------------------------------------------------------------
  # Execute Query
  # -----------------------------------------------------------------

  # query: 'SELECT Table.ColumnA, Table.ColumnB FROM Table WHERE user_id = ?'
  # args: #{user_id}
  # return: {A1:B1, ..., An:Bn}
  def self.select_hash_with_user_id(user_id, query)
    # validate
    return if user_id.blank?

    # execute
    args = [query, user_id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    result = ActiveRecord::Base.connection.execute(sql)

    # interface
    result.to_h || {}
  end
end
