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
        count(R.id) AS size
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
end
