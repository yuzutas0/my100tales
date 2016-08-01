# finders/tale_searchable.rb
module TaleSearchable extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model

    # index info
    INDEX_FIELDS = %w(title content).freeze
    index_name "es_my100tales_tale_#{Rails.env}"

    # mapping
    settings do
      mappings dynamic: 'false' do
        indexes :title, analyzer: 'kuromoji', type: 'string'
        indexes :content, analyzer: 'kuromoji', type: 'string'
      end
    end

    # create data
    # @return [Hash]
    def as_indexed_json(option = {})
      self.as_json.select { |k, _| INDEX_FIELDS.include?(k) }
    end
  end

  module ClassMethod
    # create index
    def create_index!
      client = __elasticsearch__.client
      client.indices.delete index: self.index_name rescue nil
      client.indices.create(index: self.index_name,
                            body: {
                                settings: self.settings.to_hash,
                                mappings: self.mappings.to_hash
                            })
    end
  end
end
