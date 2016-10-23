# tale form
class TaleForm
  attr_reader :tags, :scores

  def initialize(params = {})
    @tags = params[:tags]
    @scores = []
  end

  # @tags = 'tag1,tag2,score:value1,score:value2'
  # => @tags = ['tag1','tag2']
  # => @scores = [{'score':'value1'},{'score':'value2'}]
  def form_to_object
    all_list = @tags.split(',').map(&:html_safe)
    score_list = all_list.grep(/.+:.+/)
    @tags = all_list - score_list
    score_list.each do |score|
      score_content = score.split(':', 2)
      @scores << { score_content[0] => score_content[1] }
    end
    self
  end
end
