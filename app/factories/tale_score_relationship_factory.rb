# tale_score_relationship_factory
class TaleScoreRelationshipFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # INSERT INTO tale_score_relationships (tale_id, score_id)
  # SELECT #{tale_id}, S.id FROM scores S
  # WHERE CONCAT(S.key_name, ':', S.value)
  # IN (#{score_hash_list[0][key] + ':' + score_hash_list[0][value]}, ...)
  def self.create_by_score_hash_list(tale_id, score_hash_list)
    # validate
    return if score_hash_list.blank?

    # query
    query = <<-'SQL'.freeze
      INSERT INTO
          tale_score_relationships (
            tale_id,
            score_id
          )
        SELECT
            ?,
            S.id
        FROM
            scores S
        WHERE
            CONCAT(S.key_name, ':', S.value) IN (?)
    SQL

    # execute
    connected = score_hash_list.map { |hash| hash.keys.first + ':' + hash.values.first }
    args = [query, tale_id, connected]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end
