# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM tags WHERE user_id = #{user_id}
  def self.list(user_id)
    Tag.where('user_id = ?', user_id) || []
  end

  # SELECT name FROM tags WHERE user_id = #{user_id}
  def self.name_list(user_id)
    Tag.where('user_id = ?', user_id).pluck(:name) || []
  end

  # SELECT * FROM tags WHERE user_id = #{user_id} AND view_number = #{view_number}
  def self.detail(user_id, view_number)
    Tag.where('user_id = ? AND view_number = ?', user_id, view_number).first
  end

  # get hash about tag's view_number and how many tales tag is attached to
  # => { view_number: size, ... }
  # => e.g. { 1: 21, 2: 15, 3: 23 }
  #
  # SELECT T.view_number, count(R.id) AS size
  # FROM tags T
  # LEFT OUTER JOIN tale_tag_relationships R -- count for zero attached record
  # ON T.id = R.tag_id
  # WHERE T.user_id = #{user_id}
  # GROUP BY T.id
  def self.attached_count(user_id)
    return if user_id.blank?
    args = ['
      SELECT
        T.view_number,
        count(R.id) AS size
      FROM
        tags T
      LEFT OUTER JOIN -- count for zero attached record
        tale_tag_relationships R
      ON
        T.id = R.tag_id
      WHERE
        T.user_id = ?
      GROUP BY
        T.id
      ', user_id]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    result = ActiveRecord::Base.connection.execute(sql)
    result.to_h || {}
  end
end
