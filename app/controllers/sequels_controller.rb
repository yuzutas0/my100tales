#
# SequelsController
#
class SequelsController < ApplicationController

  # POST /sequels
  def create
    Sequel.transaction do
      @tale = Tale.detail(params[:view_number], current_user)
      @sequel = @tale.sequels.build(sequel_params)
      if @sequel.save
        flash[:notice] = 'Sequel was successfully created.'
      else
        set_flash
      end
      redirect_to "/tales/#{params[:view_number]}?sequels=post"
    end
  end

  private

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