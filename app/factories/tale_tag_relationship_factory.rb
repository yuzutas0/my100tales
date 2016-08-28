# tale_tag_relationship_factory
class TaleTagRelationshipFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # create only new relations for the user
  def self.create_only_new_relation(tale, only_new_tag_list)
    return if only_new_tag_list.blank?
    new_relations = []
    only_new_tag_list.each { |new_tag| new_relations << TaleTagRelationship.new(tale: tale, tag: new_tag) }
    TaleTagRelationship.bulk_import(new_relations)
  end
end
