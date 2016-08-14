#
# TalesController
#
class TalesController < ApplicationController
  before_action :set_tale, only: [:show, :edit, :update, :destroy]

  # GET /tales
  def index
    @queries = SearchForm.new(params)
    @tales = TaleService.list(current_user.id, @queries)
  end

  # GET /tales/1
  def show
    @sequels = Sequel.list(@tale.id)
    @new_sequel = Sequel.new
    @tab_class = TaleDecorator.tab(params)
  end

  # GET /tales/new
  def new
    @tale = Tale.new
  end

  # GET /tales/1/edit
  def edit
  end

  # POST /tales
  def create
    @tale = TaleService.create(tale_params, current_user)
    if @tale.present?
      redirect_to @tale, notice: 'Tale was successfully created.'
    else
      flash.now[:alert] = TaleDecorator.flash(@tale)
      render :new
    end
  end

  # PATCH/PUT /tales/1
  def update
    if @tale.update(tale_params)
      redirect_to @tale, notice: 'Tale was successfully updated.'
    else
      flash.now[:alert] = TaleDecorator.flash(@tale)
      render :edit
    end
  end

  # DELETE /tales/1
  def destroy
    @tale.destroy
    redirect_to tales_url, notice: 'Tale was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tale
    @tale = TaleService.detail(params[:view_number], current_user.id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tale_params
    params.require(:tale).permit(:title, :content)
  end
end
