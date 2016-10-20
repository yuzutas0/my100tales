# searchables/tale_score_relationship_searchable.rb
module TaleScoreRelationshipSearchable
  extend ActiveSupport::Concern
  include ApplicationSearchable

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # mapping
    mappings dynamic: 'false', _parent: { type: 'tale' } do
      indexes :id,         type: 'integer', index: 'not_analyzed'
      indexes :tale_id,    type: 'integer', index: 'not_analyzed'
      indexes :score_id,   type: 'integer', index: 'not_analyzed'
      indexes :created_at, type: 'date',    index: 'not_analyzed', format: 'date_time'
      indexes :updated_at, type: 'date',    index: 'not_analyzed', format: 'date_time'
    end
  end
end
