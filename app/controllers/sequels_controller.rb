#
# SequelsController
#
class SequelsController < ApplicationController
  before_action :set_sequel, only: [:edit, :update, :destroy]

  # POST /sequels
  def create
    Sequel.transaction do
      @tale = Tale.detail(params[:view_number], current_user)
      @sequel = Sequel.instance(sequel_params, @tale)
      if @sequel.save
        flash[:notice] = 'Sequel was successfully created.'
      else
        set_flash
      end
      redirect_to "/tales/#{params[:view_number]}?sequels=posted"
    end
  end

  # DELETE /tales/1
  def destroy
    @sequel.destroy
    redirect_to "/tales/#{params[:view_number]}?sequels=deleted", notice: 'Sequel was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sequel
    @sequel = Sequel.detail(current_user.id, params[:view_number], params[:sequel_view_number])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sequel_params
    params.require(:sequel).permit(:content)
  end

  # add flash message about error reasons
  def set_flash
    flash[:alert] = []
    @sequel.errors.full_messages.each { |message| flash[:alert] << message + '<br>' }
  end
end