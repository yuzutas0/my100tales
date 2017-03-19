# tale form
class TaleForm
  attr_reader :tags, :scores

  def initialize(params = {})
    @tags = self.class.escape(params[:tags])
    @scores = []
  end

  # @tags = 'tag1,tag2,score:value1,score:value2'
  # => @tags = ['tag1','tag2']
  # => @scores = [{'score':'value1'},{'score':'value2'}]
  def form_to_object
    all_list = @tags.split(',').map(&:html_safe)
    remove_list = all_list.grep(/\A.+:\z/) # 'score:'
    score_list = all_list.grep(/\A.+:.+\z/) # 'score:value'
    @tags = all_list - score_list - remove_list
    score_list.each do |score|
      score_content = score.partition(':')
      @scores << { score_content[0] => score_content[2] }
    end
    self
  end

  # same as: javascripts/util/xss.coffee#escapeString
  def self.escape(tag = '')
    tag.gsub(%r{[&<>"'`=/]}, '').strip
  end
end
