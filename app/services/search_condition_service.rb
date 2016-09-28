# search_condition_service
class SearchConditionService
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # called by TaleService#list
  def foobar(user, params)
    # get present list
    present_list = SearchConditionRepository.select_by_user(user.id)
    return present_list if params[:query_string].blank?

    # -> if query has been not already saved
    #   -> create new history
    SearchConditionFactory.create(user, params, false)
    #   -> if the history record size is over five
    #      -> delete history to make size five (wanna delete oldest records)

    # -> if query has been already saved
    #   -> update the record's time
    search_condition = SearchCondition.new # FIXME
    SearchConditionRepository.update_time(search_condition)

    # if param exists && save_flag == true
    #   -> create new save
    SearchConditionFactory.create(user, params, true)
    #   -> if the record size is over five
    #     -> delete record to make size five (wanna delete oldest records)

    # return all records
    SearchConditionRepository.select_by_user(user.id)
  end
end
