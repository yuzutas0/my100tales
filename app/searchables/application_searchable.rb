# searchables/application_searchable.rb
module ApplicationSearchable

  # called by model
  INDEX_NAME = "es_my100tales_tale_#{Rails.env}"
  CLIENT = Elasticsearch::Client.new host: Rails.application.secrets.elastic_search_host

  # called by searchable
  SETTINGS = {
      index: {
        number_of_shards:   1,
        number_of_replicas: 0,
        analysis: {
            filter: {
                pos_filter: {
                    type:     'kuromoji_part_of_speech',
                    stoptags: %w(助詞-格助詞-一般 助詞-終助詞)
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
      }
  }
end
