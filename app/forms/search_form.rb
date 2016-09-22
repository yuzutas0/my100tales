# search form
class SearchForm
  attr_accessor :page, :keyword, :tags

  def initialize(params = {})
    @page = params[:page] || 1
    @keyword = params[:keyword].html_safe if params[:keyword].present?
    @tags = if params[:tags].present? && params[:tags][:id].present?
              params[:tags][:id].map { |tag| tag.to_i }
            else
              []
            end
  end
end
