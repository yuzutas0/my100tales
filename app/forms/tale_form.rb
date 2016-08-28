# tale form
class TaleForm
  attr_reader :tags

  def initialize(params = {})
    @tags = params[:tags]
  end

  def form_to_object
    @tags = @tags.split(' ')
  end
end
