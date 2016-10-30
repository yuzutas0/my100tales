# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :scores, :sort, :save, :name, :query_string

  DEFAULT_PAGE = 1
  DEFAULT_KEYWORD = nil
  DEFAULT_TAGS = [].freeze
  DEFAULT_SCORES = [].freeze
  DEFAULT_SORT = 0

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {}, request_path = '')
    # for search
    @page = params[:page] || DEFAULT_PAGE
    @keyword = params[:keyword].present? ? params[:keyword].html_safe : DEFAULT_KEYWORD
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : DEFAULT_TAGS
    @scores = valid_scores?(params[:scores]) ? convert_scores(params[:scores]) : DEFAULT_SCORES
    @sort = valid_sort?(params[:sort]) ? params[:sort].to_i : DEFAULT_SORT
    # for save
    @save = params[:save] == true.to_s
    @name = params[:name].html_safe if params[:name].present?
    @query_string = request_path.include?('?') ? convert_query_string : ''
  end

  # -----------------------------------------------------------------
  # Master Enum
  # -----------------------------------------------------------------

  # refs. config/locales/defaults/en.yml
  # 0: Newer Create - t('master.sort.option_0')
  # 1: Older Create - t('master.sort.option_1')
  # 2: Newer Update - t('master.sort.option_2')
  # 3: Older Update - t('master.sort.option_3')
  def self.sort_master
    [
      { created_at: :desc }, # 0
      { created_at: :asc  }, # 1
      { updated_at: :desc }, # 2
      { updated_at: :asc  }, # 3
    ]
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

  def valid_scores?(scores)
    scores.present? && scores[:id].is_a?(Array)
  end

  def convert_scores(scores)
    scores[:id].map(&:to_i)
  end

  def valid_sort?(sort)
    value_range = [*0..(self.class.sort_master.length - 1)]
    sort.present? && value_range.include?(sort.to_i)
  end

  def convert_query_string
    query = ''
    query = add_query(query, 'keyword', @keyword) unless @keyword == DEFAULT_KEYWORD
    @tags.each { |tag| query = add_query(query, 'tags[id][]', tag.to_s) } unless @tags == DEFAULT_TAGS
    query = add_query(query, 'sort', @sort.to_s) unless @sort == DEFAULT_SORT
    query
  end

  def add_query(query, key, value)
    query += '&' if query.present?
    query + key + '=' + value
  end
end
