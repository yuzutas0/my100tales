# sequel_repository
class SequelRepository
  # get hash about tale_id and how many sequels is posted to the tale
  # => { tale_id: size, ... }
  # => e.g. { 1: 15, 2: 0, 3: 4 }
  def self.tale_id_and_attached_count(tale_id_list)
    # query
    query = <<-'SQL'.freeze
      SELECT
        T.id,
        count(S.id) AS size
      FROM
        tales T
      LEFT OUTER JOIN -- count for zero attached record
        sequels S
      ON
        T.id = S.tale_id
      WHERE
        T.id IN (?)
      GROUP BY
        T.id
    SQL

    # execute
    args = [query, tale_id_list]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql).to_h || {}
  end
end
