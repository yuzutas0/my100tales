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
    success = ScoreService.update(@score, score_params, current_user.id)
    message = t('views.message.destroy.success')
    render_scores(success, message)
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /scores/:view_number
  def destroy
    success = @score.destroy
    message = t('views.message.destroy.success')
    render_scores(success, message)
  end

  # FIXME: use this endpoint!!
  # DELETE /scores/key/:key
  def destroy_by_key
    success = ScoreService.delete_by_key(current_user.id, params[:key])
    message = t('views.message.destroy.success')
    render_scores(success, message)
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

  # common logic called by update, delete
  def render_scores(success, message)
    if success
      flash[:notice] = message
    else
      flash[:alert] = ScoreDecorator.flash(@score, flash)
    end
    redirect_to scores_url
  end
end
