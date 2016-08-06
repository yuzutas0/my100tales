# finders/tale_searchable.rb
module TaleSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name "es_my100tales_tale_#{Rails.env}"

    # mapping
    settings index: {
        number_of_shards:   1,
        number_of_replicas: 0,
        analysis: {
            filter: {
                pos_filter: {
                    type:     'kuromoji_part_of_speech',
                    stoptags: ['助詞-格助詞-一般', '助詞-終助詞'],
                },
                greek_lowercase_filter: {
                    type:     'lowercase',
                    language: 'greek',
                },
            },
            tokenizer: {
                kuromoji: {
                    type: 'kuromoji_tokenizer'
                },
                ngram_tokenizer: {
                    type: 'nGram',
                    min_gram: '2',
                    max_gram: '3',
                    token_chars: ['letter', 'digit']
                }
            },
            analyzer: {
                kuromoji_analyzer: {
                    type:      'custom',
                    tokenizer: 'kuromoji_tokenizer',
                    filter:    ['kuromoji_baseform', 'pos_filter', 'greek_lowercase_filter', 'cjk_width'],
                },
                ngram_analyzer: {
                    tokenizer: "ngram_tokenizer"
                }
            }
        }
    } do
      mappings dynamic: 'false' do
        indexes :title, type: 'string', index: 'analyzed', analyzer: 'kuromoji_analyzer'
        indexes :content, type: 'string', index: 'analyzed', analyzer: 'kuromoji_analyzer'
      end
    end
  end

  module ClassMethods
    def create_index!(options={})
      client = __elasticsearch__.client
      client.indices.delete index: self.index_name rescue nil if options[:force]
      client.indices.create(index: self.index_name,
                            body: {
                                settings: self.settings.to_hash,
                                mappings: self.mappings.to_hash
                            })
    end
  end
end
