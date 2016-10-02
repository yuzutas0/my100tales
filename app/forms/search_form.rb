# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :sort, :save, :name, :query_string

  DEFAULT_PAGE = 1
  DEFAULT_KEYWORD = nil
  DEFAULT_TAGS = []
  DEFAULT_SORT = 0

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {}, request_path = '')
    # for search
    @page = params[:page] || DEFAULT_PAGE
    @keyword = params[:keyword].present? ? params[:keyword].html_safe : DEFAULT_KEYWORD
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : DEFAULT_TAGS
    @sort = valid_sort?(params[:sort]) ? params[:sort].to_i : DEFAULT_SORT
    # for save
    @save = params[:save] == true.to_s
    @name = params[:name].html_safe if params[:name].present?
    @query_string = request_path.include?('?') ? convert_query_string : ''
  end

  # -----------------------------------------------------------------
  # Master Enum
  # -----------------------------------------------------------------
  # 0: Newer_Create
  # 1: Older_Create
  # 2: Newer_Update
  # 3: Older_Update
  def self.sort_master
    %w(Newer_Create Older_Create Newer_Update Older_Update)
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

  def valid_sort?(sort)
    value_range = [*0..(self.class.sort_master.length - 1)]
    sort.present? && value_range.include?(sort.to_i)
  end

  def convert_query_string
    query = ''
    query = add_query(query, 'page', @page.to_s) unless @page == DEFAULT_PAGE
    query = add_query(query, 'keyword', @keyword) unless @keyword == DEFAULT_KEYWORD
    @tags.each { |tag| query = add_query(query, 'tags[id][]', tag.to_s) } unless @tags == DEFAULT_TAGS
    query = add_query(query, 'sort', @sort.to_s) unless @sort == DEFAULT_SORT
    query
  end

  def add_query(query, key, value)
    query = query + '&' if query.present?
    query + key + '=' + value
  end
end
