# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :sort, :save, :name, :query_string

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {}, request_path = '')
    @page = params[:page] || 1
    @keyword = params[:keyword].html_safe if params[:keyword].present?
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : []
    @sort = valid_sort?(params[:sort]) ? params[:sort].to_i : 0
    @save = params[:save].is_a?(TrueClass)
    @name = params[:name].html_safe if params[:name].present?
    @query_string = request_path.include?('?') ? request_path.html_safe.split('?')[1] : ''
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
    tags.present? && tags[:id].is_a?(Integer)
  end

  def convert_tags(tags)
    tags[:id].map(&:to_i)
  end

  def valid_sort?(sort)
    value_range = [*0..(self.class.sort_master.length - 1)]
    sort.is_a?(Integer) && value_range.include?(sort.to_i)
  end
end
