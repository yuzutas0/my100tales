#
# SearchConditionsController
#
class SearchConditionsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_search_condition, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /searches
  def index
    @search_conditions = SearchConditionService.list(current_user.id)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /searches/:view_number
  def update
    if @search_condition.update(search_condition_params)
      flash[:notice] = t('views.message.update.success')
    else
      flash[:alert] = SearchConditionDecorator.flash(@search_condition, flash)
    end
    redirect_to search_conditions_url
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /searches/:view_number
  def destroy
    if @search_condition.destroy
      flash[:notice] = t('views.message.destroy.success')
    else
      flash[:alert] = SearchConditionDecorator.flash(@search_condition, flash)
    end
    redirect_to search_conditions_url
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_search_condition
    @search_condition = SearchConditionService.detail(current_user.id, params[:view_number])
    routing_error if @search_condition.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_condition_params
    params.require(:search_condition).permit(:name, :query_string, :view_number)
  end
end
