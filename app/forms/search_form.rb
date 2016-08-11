# search form
class SearchForm
  attr_accessor :page, :keyword

  def initialize(params = {})
    @page = params[:page] || 1
    @keyword = params[:keyword]
  end
end
