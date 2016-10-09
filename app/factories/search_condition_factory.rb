# search_condition_factory
class SearchConditionFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of user_id and view_number unique
  def self.create(user, query_string, save_flag, name)
    name = save_flag && name.present? ? name : ''
    view_number = increment_view_number(user.id)
    user.search_conditions.build(
      query_string: query_string, save_flag: save_flag, name: name, view_number: view_number
    ).save
  end

  # support method
  def self.increment_view_number(user_id)
    last = SearchCondition.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
