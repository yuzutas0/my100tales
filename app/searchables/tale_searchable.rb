# searchables/tale_searchable.rb
module TaleSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # mapping
    settings ApplicationSearchable::SETTINGS do
      mappings dynamic: 'false' do
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

  # methods
  module ClassMethods
    # create index
    def create_index
      # ready
      settings = Tale.settings.to_hash.merge TaleTagRelationship.settings.to_hash
      mappings = Tale.mappings.to_hash.merge TaleTagRelationship.mappings.to_hash

      # change index
      delete_index(force: true)
      __elasticsearch__.client.indices.create(
        index: index_name,
        body: {
          settings: settings.to_hash,
          mappings: mappings.to_hash
        }
      )
      import_index
    end

    # import index
    def import_index
      __elasticsearch__.import
    end

    # delete index
    def delete_index(options = {})
      begin
        __elasticsearch__.client.indices.delete index: index_name
      rescue
        nil
      end if options[:force]
    end
  end
end
