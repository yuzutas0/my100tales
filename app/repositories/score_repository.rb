# score_repository
class ScoreRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM scores WHERE user_id = #{user_id} ORDER BY key_name, value
  def self.list(user_id)
    Score.where('user_id = ?', user_id).order(:key_name, value: :asc) || []
  end

  # SELECT * FROM scores WHERE user_id = #{user_id} AND view_number = #{view_number}
  def self.detail(user_id, view_number)
    Score.where('user_id = ? AND view_number = ?', user_id, view_number).first
  end

  # SELECT DISTINCT key_name FROM scores WHERE user_id = #{user_id} ORDER BY view_number
  def self.key_names(user_id)
    Score.where('user_id = ?', user_id).order(:view_number).distinct.pluck(:key_name)
  end

  def self.max_value(user_id, key)
    Score.maximum('value', conditions: { user_id: user_id, key_name: key })
  end

  # get hash about score's view_number and how many tales the score is attached to
  # => { view_number: size, ... }
  # => e.g. { 1: 21, 2: 15, 3: 23 }
  def self.view_number_and_attached_count(user_id)
    # query
    query = <<-'SQL'.freeze
      SELECT
        S.view_number,
        COUNT(R.id)
      FROM
        scores S
      LEFT OUTER JOIN -- count for zero attached record
        tale_score_relationships R
      ON
        S.id = R.score_id
      WHERE
        S.user_id = ?
      GROUP BY
        S.id
    SQL
    # execute
    CommonRepository.select_hash_with_user_id(user_id, query)
  end

  # get hash about score's key: and how many tales the score is attached to
  # => { 'key:': size, ... }
  # => e.g. { 'testOne:': 21, 'test2:': 15, 'test_three:': 23 }
  def self.key_and_attached_count(user_id)
    # query
    query = <<-'SQL'.freeze
      SELECT
        CONCAT(S.key_name, ':'),
        count(R.id)
      FROM
        scores S
      LEFT OUTER JOIN -- count for zero attached record
        tale_score_relationships R
      ON
        S.id = R.score_id
      WHERE
        S.user_id = ?
      GROUP BY
        S.key_name
    SQL
    # execute
    CommonRepository.select_hash_with_user_id(user_id, query)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  def self.update(score, params)
    score.update(params)
  end

  def self.update_key(score, key, user_id)
    # valid
    return false if key.blank?
    # query
    query = <<-'SQL'.freeze
      UPDATE
        scores S
      SET
        S.key_name = ?
      WHERE
        S.key_name = ?
        AND S.user_id = ?
        AND S.user_id = ?
    SQL
    # execute
    args = [query, key, score.key_name, score.user_id, user_id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    result = ActiveRecord::Base.connection.update(sql)
    # return
    result > 0
  end

  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # *** use transaction ***
  # *** call after TaleScoreRelationshipRepository#delete_by_score_keys
  # in order to avoid constraint error at database
  def self.delete_by_key(user_id, key)
    return if key.blank?
    Score.where('user_id = ? AND key_name = ?', user_id, key).delete_all
  end
end
