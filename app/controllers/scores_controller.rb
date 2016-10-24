#
# ScoresController
#
class ScoresController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_score, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /scores
  def index
    @scores, @scores_attached = ScoreService.list(current_user.id)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /scores/:view_number
  def update
    if ScoreService.update(@score, score_params, current_user.id)
      flash[:notice] = t('views.message.update.success')
    else
      flash[:alert] = ScoreDecorator.flash(@score, flash)
    end
    redirect_to scores_url
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /scores/:view_number
  def destroy
    if @score.destroy
      flash[:notice] = t('views.message.destroy.success')
    else
      flash[:alert] = ScoreDecorator.flash(@score, flash)
    end
    redirect_to scores_url
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_score
    @score = ScoreService.detail(current_user.id, params[:view_number])
    routing_error if @score.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def score_params
    params.require(:score).permit(:key, :value, :view_number)
  end
end
