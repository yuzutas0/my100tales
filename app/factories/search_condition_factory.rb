# search_condition_factory
class SearchConditionFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  def self.create(user, params, save_flag)
    search_condition = SearchCondition.new
    search_condition.user = user
    search_condition.save_flag = save_flag
    search_condition.name = params[:name] if search_condition.save_flag
    search_condition.query_string = params[:query_string]
    search_condition.save
  end
end
