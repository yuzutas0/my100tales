# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :scores, :sort, :save, :name, :query_string

  DEFAULT_PAGE = 1
  DEFAULT_KEYWORD = nil
  DEFAULT_TAGS = [].freeze
  DEFAULT_SCORES = {}.freeze
  DEFAULT_SORT = -1.to_s

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {}, request_path = '', score_master = [])
    # for search
    @page = params[:page] || DEFAULT_PAGE
    @keyword = params[:keyword].present? ? params[:keyword].html_safe : DEFAULT_KEYWORD
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : DEFAULT_TAGS
    @scores = valid_scores?(params[:scores], score_master) ? convert_scores(params[:scores]) : DEFAULT_SCORES
    @sort = valid_sort?(params[:sort], score_master) ? params[:sort] : DEFAULT_SORT
    # for save
    @save = params[:save] == true.to_s
    @name = params[:name].html_safe if params[:name].present?
    @query_string = request_path.include?('?') ? convert_query_string : ''
  end

  # -----------------------------------------------------------------
  # Master Enum
  # -----------------------------------------------------------------

  # *** use with ScoreService#sort_master ***
  # refs. config/locales/defaults/en.yml
  # -1: Newer Create - t('master.sort.option_0')
  # -2: Older Create - t('master.sort.option_1')
  # -3: Newer Update - t('master.sort.option_2')
  # -4: Older Update - t('master.sort.option_3')
  def self.sort_master
    [
      { created_at: :desc }, # -1
      { created_at: :asc  }, # -2
      { updated_at: :desc }, # -3
      { updated_at: :asc  }, # -4
    ]
  end

  # ge - '>='
  # eq - '=='
  # le - '<='
  def self.compare_master
    [ { ge: '>=' }, { eq: '=' }, { le: '<=' } ]
  end

  def self.compare_to_query(compare)
    hash = {}
    compare_master.each { |item| hash[item.keys.first] = item.values.first }
    hash[compare.to_sym]
  end

  # -----------------------------------------------------------------
  # Support - validator, converter
  # -----------------------------------------------------------------
  private

  def valid_tags?(tags)
    tags.present? && tags[:id].is_a?(Array)
  end

  def convert_tags(tags)
    tags[:id].map(&:to_i)
  end

  def valid_scores?(scores, score_master)
    scores.present? &&
      scores[:key].is_a?(Array) &&
      scores[:co].is_a?(Array) &&
      scores[:val].is_a?(Array) &&
      scores[:key].length == scores[:co].length &&
      scores[:key].length == scores[:val].length &&
      scores[:key].all? { |key| array_of(score_master).include?(key) } &&
      scores[:co].all? do |co|
        divided(co).length == 2 &&
          divided(co)[1].present? &&
          scores[:key].include?(divided(co)[0]) &&
          array_of(self.class.compare_master).include?(divided(co)[1])
      end &&
      scores[:val].all? do |val|
        divided(val).length == 2 &&
          divided(val)[1].present? &&
          scores[:key].include?(divided(val)[0])
      end &&
      scores[:key].all? do |key|
        (scores[:co].map { |co| divided(co)[0] }).include?(key) &&
          (scores[:val].map { |val| divided(val)[0] }).include?(key)
      end
  end

  def array_of(hash_array)
    hash_array.map { |hash| hash.keys.first.to_s }
  end

  def divided(item)
    item.split(':', 2)
  end

  def convert_scores(scores)
    {
      key: scores[:key].map(&:html_safe),
      co: scores[:co],
      val: scores[:val].map(&:html_safe)
    }
  end

  def valid_sort?(sort, score_master)
    default_range = [*(-1 * self.class.sort_master.length...0)].map(&:to_s)
    score_range = score_master.map { |item| item.keys.first.to_s + ':' + item.values.first.to_s }
    value_range = default_range + score_range
    sort.present? && value_range.include?(sort.to_s)
  end

  def convert_query_string
    query = ''
    query = add_query(query, 'keyword', @keyword) unless @keyword == DEFAULT_KEYWORD
    @tags.each { |tag| query = add_query(query, 'tags[id][]', tag.to_s) } unless @tags == DEFAULT_TAGS
    @scores.keys.each do |key|
      next unless @scores[key.to_sym].present?
      @scores[key.to_sym].each { |item| query = add_query(query, "scores[#{key}][]", item) }
    end
    query = add_query(query, 'sort', @sort.to_s) unless @sort == DEFAULT_SORT
    query
  end

  def add_query(query, key, value)
    query += '&' if query.present?
    query + key + '=' + value
  end
end
