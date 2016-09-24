# searchables/tale_tag_relationship_searchable.rb
module TaleTagRelationshipSearchable
  extend ActiveSupport::Concern
  include ApplicationSearchable

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # mapping
    settings ApplicationSearchable::SETTINGS do
      mappings dynamic: 'false', _parent: { type: 'tale' } do
        indexes :id,         type: 'integer', index: 'not_analyzed'
        indexes :tale_id,    type: 'integer', index: 'not_analyzed'
        indexes :tag_id,     type: 'integer', index: 'not_analyzed'
        indexes :created_at, type: 'date',    index: 'not_analyzed', format: 'date_time'
        indexes :updated_at, type: 'date',    index: 'not_analyzed', format: 'date_time'
      end
    end
  end
end
