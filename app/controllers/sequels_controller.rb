#
# SequelsController
#
class SequelsController < ApplicationController
  # -----------------------------------------------------------------
  # include
  # -----------------------------------------------------------------
  include ErrorHandlers

  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_sequel, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # POST /sequels
  def create
    @tale, @sequel, success = SequelService.create(sequel_params, params[:view_number], current_user.id)
    if success
      flash[:notice] = 'Sequel was successfully created.'
    else
      flash[:alert] = SequelDecorator.flash(@sequel, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?sequels=created"
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /sequels
  def update
    if @sequel.update(sequel_params)
      flash[:notice] = 'Sequel was successfully updated.'
    else
      flash[:alert] = SequelDecorator.flash(@sequel, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?sequels=updated"
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /sequels
  def destroy
    if @sequel.destroy
      flash[:notice] = 'Sequel was successfully destroyed.'
    else
      flash[:alert] = SequelDecorator.flash(@sequel, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?sequels=deleted"
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sequel
    @sequel = SequelService.detail(current_user.id, params[:view_number], params[:sequel_view_number])
    render_404 if @sequel.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sequel_params
    params.require(:sequel).permit(:content)
  end
end
