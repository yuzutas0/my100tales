#
# TalesController
#
class TalesController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_tale, only: [:edit, :update, :destroy]
  before_action :set_tale_with_options, only: [:show]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # GET /tales/new
  def new
    @tale = TaleService.new
    ready_form(@tale, current_user.id)
  end

  # POST /tales
  def create
    @tale, success = TaleService.create(tale_params, option_form_params, current_user)
    if success
      redirect_to @tale, notice: t('views.message.create.success')
    else
      flash.now[:alert] = TaleDecorator.flash(@tale, flash)
      ready_form(@tale, current_user.id, tags_params_string)
      render :new
    end
  end

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /tales
  def index
    @queries = SearchForm.new(params, request.fullpath)
    @is_searched, @search_conditions = SearchConditionService.request(current_user, @queries)
    @tales, @tags, @tags_attached, @sequels_attached = TaleService.list(current_user.id, @queries)
    @sort_master = SearchForm.sort_master
  end

  # GET /tales/1
  def show
    @new_sequel = Sequel.new
    @tab_class = TaleDecorator.tab(params)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # GET /tales/1/edit
  def edit
    ready_form(@tale, current_user.id)
  end

  # PATCH/PUT /tales/1
  def update
    @tale, success = TaleService.update(@tale, tale_params, option_form_params, current_user)
    if success
      redirect_to @tale, notice: t('views.message.update.success')
    else
      flash.now[:alert] = TaleDecorator.flash(@tale, flash)
      ready_form(@tale, current_user.id, tags_params_string)
      render :edit
    end
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /tales/1
  def destroy
    @tale.destroy
    redirect_to tales_url, notice: t('views.message.destroy.success')
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # -----------------------------------------------------------------
  # for filter
  # -----------------------------------------------------------------
  # Use callbacks to share common setup or constraints between actions.
  def set_tale
    @tale = TaleService.detail(params[:view_number], current_user.id)
    routing_error if @tale.blank?
  end

  def set_tale_with_options
    @tale = TaleService.detail_with_options(params[:view_number], current_user.id)
    routing_error if @tale.blank?
  end

  # set some params for tale form
  def ready_form(tale, user_id, tags = '')
    @form = TaleDecorator.option_form(tale, tags)
    @tags = TagService.name_and_attached_count(user_id)
  end

  # -----------------------------------------------------------------
  # for strong parameter
  # -----------------------------------------------------------------
  # Never trust parameters from the scary internet, only allow the white list through.
  def tale_params
    params.require(:tale).permit(:title, :content)
  end

  def tags_params_string
    params.require(:form).permit(:tags)[:tags]
  end

  # Get option form
  def option_form_params
    option_form = params.require(:form).permit(:tags)
    TaleForm.new(tags: option_form[:tags]).form_to_object
  end
end
