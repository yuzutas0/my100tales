# searchables/tale_searchable.rb
module TaleSearchable
  extend ActiveSupport::Concern
  include ApplicationSearchable

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # mapping
    mapping dynamic: 'false' do
      indexes :id,          type: 'integer', index: 'not_analyzed'
      indexes :title,       type: 'string',  index: 'analyzed', analyzer: 'kuromoji_analyzer'
      indexes :content,     type: 'string',  index: 'analyzed', analyzer: 'kuromoji_analyzer'
      indexes :view_number, type: 'integer', index: 'not_analyzed'
      indexes :user_id,     type: 'integer', index: 'not_analyzed'
      indexes :created_at,  type: 'date',    index: 'not_analyzed', format: 'date_time'
      indexes :updated_at,  type: 'date',    index: 'not_analyzed', format: 'date_time'
    end
  end
end
