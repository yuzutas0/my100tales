#
# SequelsController
#
class SequelsController < ApplicationController

  # POST /sequels
  def create
    Sequel.transaction do
      @tale = Tale.detail(params[:view_number], current_user)
      sequel = @tale.sequels.build(sequel_params)
      puts "1111111111"
      puts sequel.attributes
      if sequel.save
        redirect_to @tale, notice: 'Sequel was successfully created.'
      else
        raise
        redirect_to @tale, alert: 'Error - sequel was not created!'
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def sequel_params
    params.require(:sequel).permit(:content)
  end
end