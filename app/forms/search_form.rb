# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :sort

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {})
    @page = params[:page] || 1
    @keyword = params[:keyword].html_safe if params[:keyword].present?
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : []
    @sort = valid_sort?(params[:sort]) ? params[:sort].to_i : 0
  end

  # -----------------------------------------------------------------
  # Master Enum
  # -----------------------------------------------------------------
  def self.sort_master
    %w(Newer_Update Older_Update More_Sequels Less_Sequels)
  end

  # -----------------------------------------------------------------
  # Support - validator, converter
  # -----------------------------------------------------------------
  private

  def valid_tags?(tags)
    tags.present? && tags[:id].present?
  end

  def convert_tags(tags)
    tags[:id].map { |tag| tag.to_i }
  end

  def valid_sort?(sort)
    value_range = [*0..(self.class.sort_master.length - 1)]
    sort.present? && value_range.include?(sort.to_i)
  end
end
