#
# TalesController
#
class TalesController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_tale, only: [:show, :edit, :update, :destroy]
  after_action :set_form_options, only: [:new, :edit]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # GET /tales/new
  def new
    @tale = Tale.new
  end

  # POST /tales
  def create
    @tale, success = TaleService.create(tale_params, current_user)
    if success
      redirect_to @tale, notice: 'Tale was successfully created.'
    else
      flash.now[:alert] = TaleDecorator.flash(@tale, flash)
      render :new
    end
  end

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /tales
  def index
    @queries = SearchForm.new(params)
    @tales = TaleService.list(current_user.id, @queries)
  end

  # GET /tales/1
  def show
    @sequels, @new_sequel = SequelService.list(@tale.id)
    @tab_class = TaleDecorator.tab(params)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # GET /tales/1/edit
  def edit
  end

  # PATCH/PUT /tales/1
  def update
    if @tale.update(tale_params)
      redirect_to @tale, notice: 'Tale was successfully updated.'
    else
      flash.now[:alert] = TaleDecorator.flash(@tale, flash)
      render :edit
    end
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /tales/1
  def destroy
    @tale.destroy
    redirect_to tales_url, notice: 'Tale was successfully destroyed.'
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tale
    @tale = TaleService.detail(params[:view_number], current_user.id)
    routing_error if @tale.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tale_params
    params.require(:tale).permit(:title, :content)
  end

  # set tags to form view
  def set_form_options
    params = {}
    params[:tags] = ready_tags
    @form = TaleForm.new(params)
  end

  # ready tags for form option
  def ready_tags
    tags = ''
    @tale.tags.each { |tag| tags = tags + ' ' + tag } if @tale.tags.present?
    tags
  end
end
