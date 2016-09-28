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

    # -> if query has been not already saved (save_flag == false)
    #   -> create new history
    SearchConditionFactory.create(user, query_string, false, name)
    #   -> if the history record size is over five
    #      -> delete history to make size five (wanna delete oldest records)

    # -> if query has been already saved
    #   -> update the record's time
    search_condition = SearchCondition.new # FIXME
    SearchConditionRepository.update_time(search_condition)

    if save_flag
    # if param exists && save_flag == true
    #   -> create new save
      SearchConditionFactory.create(user, query_string, true, name)
    #   -> if the record size is over five
    #     -> delete record to make size five (wanna delete oldest records)
    end

    # return all records
    SearchConditionRepository.select_by_user(user.id)
  end
end
