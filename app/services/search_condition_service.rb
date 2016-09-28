# search_condition_service
class SearchConditionService
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # called by TaleService#list
  def foobar(user, query_string, save_flag, name)
    # get present list
    present_list = SearchConditionRepository.select_by_user(user.id)
    return present_list if query_string.blank?

    # save_flag == false && query_string == #{query_string}
    to_be_updated = (present_list.select { |item| !item.save_flag && item.query_string == query_string }).first
    if to_be_updated.present?
      SearchConditionRepository.update_time(to_be_updated)
    else
      SearchConditionFactory.create(user, query_string, false, name)
      present_size = present_list.reject(&:save_flag).length + 1
      SearchConditionRepository.delete_to_size(user.id, save_flag, present_size)
    end

    if save_flag
      SearchConditionFactory.create(user, query_string, true, name)
      present_size = present_list.select(&:save_flag).length + 1
      SearchConditionRepository.delete_to_size(user.id, save_flag, present_size)
    end

    # return all records
    SearchConditionRepository.select_by_user(user.id)
  end
end
