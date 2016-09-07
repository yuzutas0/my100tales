# tale_tag_relationship_factory
class TaleTagRelationshipFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # INSERT INTO tale_tag_relationships (tale_id, tag_id)
  # SELECT #{tale_id}, T.id FROM tags T
  # WHERE T.name IN (#{tag_name_list[0]}, ..., #{tag_name_list[n]})
  def self.create_by_tag_name_list(tale_id, tag_name_list)
    # validate
    return if tag_name_list.blank?

    # query
    query = <<-'SQL'.freeze
      INSERT INTO
          tale_tag_relationships (
            tale_id,
            tag_id
          )
        SELECT
            ?,
            T.id
        FROM
            tags T
        WHERE
            T.name IN (?)
    SQL

    # execute
    args = [query, tale_id, tag_name_list]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end
