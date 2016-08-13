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
            stoptags: ['助詞-格助詞-一般', '助詞-終助詞']
          },
          greek_lowercase_filter: {
            type:     'lowercase',
            language: 'greek'
          }
        },
        tokenizer: {
          kuromoji: {
            type: 'kuromoji_tokenizer'
          },
          ngram_tokenizer: {
            type: 'nGram',
            min_gram: '2',
            max_gram: '3',
            token_chars: %w(letter digit)
          }
        },
        analyzer: {
          kuromoji_analyzer: {
            type:      'custom',
            tokenizer: 'kuromoji_tokenizer',
            filter:    %w(kuromoji_baseform pos_filter greek_lowercase_filter cjk_width)
          },
          ngram_analyzer: {
            tokenizer: 'ngram_tokenizer'
          }
        }
      }
    } do
      mappings dynamic: 'false' do
        indexes :id,          type: 'integer', index: 'not_analyzed'
        indexes :title,       type: 'string', analyzer: 'kuromoji_analyzer'
        indexes :content,     type: 'string', analyzer: 'kuromoji_analyzer'
        indexes :view_number, type: 'integer', index: 'not_analyzed'
        indexes :user_id,     type: 'integer', index: 'not_analyzed'
        indexes :created_at,  type: 'date', format: 'date_time', index: 'not_analyzed'
        indexes :updated_at,  type: 'date', format: 'date_time', index: 'not_analyzed'
      end
    end
  end

  # methods
  module ClassMethods
    def create_index!(options = {})
      client = __elasticsearch__.client
      begin
        client.indices.delete index: index_name
      rescue
        nil
      end if options[:force]
      client.indices.create(index: index_name,
                            body: {
                              settings: settings.to_hash,
                              mappings: mappings.to_hash
                            })
    end
  end
end
