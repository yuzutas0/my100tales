# score_repository
class ScoreRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM scores WHERE user_id = #{user_id}
  def self.list(user_id)
    Score.where('user_id = ?', user_id) || []
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
        CONCAT(S.key, ':'),
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
        S.key
    SQL

    # execute
    CommonRepository.select_hash_with_user_id(user_id, query)
  end
end
