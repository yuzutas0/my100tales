# search_condition_factory
class SearchConditionFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  def self.create(user, query_string, save_flag, name)
    name = save_flag && name.present? ? name : ''
    SearchCondition.create(user: user, query_string: query_string, save_flag: save_flag, name: name)
  end
end
