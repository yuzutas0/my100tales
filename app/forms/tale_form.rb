# tale form
class TaleForm
  attr_reader :tags

  def initialize(params = {})
    @tags = params[:tags]
  end
end
