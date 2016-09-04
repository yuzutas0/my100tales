#
# TagsController
#
class TagsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_tag, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /tags
  def index
    @tags, @tags_attached = TagService.list(current_user.id)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /tags/:view_number
  def update
    if @tag.update(tag_params)
      flash[:notice] = 'Tag was successfully updated.'
    else
      flash[:alert] = TagDecorator.flash(@tag, flash)
    end
    redirect_to tags_url
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /tags/:view_number
  def destroy
    if @tag.destroy
      flash[:notice] = 'Tag was successfully destroyed.'
    else
      flash[:alert] = TagDecorator.flash(@tag, flash)
    end
    redirect_to tags_url
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = TagService.detail(current_user.id, params[:view_number])
    routing_error if @tag.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:name)
  end
end
