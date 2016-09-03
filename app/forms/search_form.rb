# search form
class SearchForm
  attr_accessor :page, :keyword, :tags

  def initialize(params = {})
    @page = params[:page] || 1
    @keyword = params[:keyword]
    @tags = if params[:tags].present?
              params[:tags][:id] || []
            else
              []
            end
  end
end
