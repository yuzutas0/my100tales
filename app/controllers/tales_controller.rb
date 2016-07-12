#
# TalesController
#
class TalesController < ApplicationController
  before_action :set_tale, only: [:show, :edit, :update, :destroy]

  # GET /tales
  # GET /tales.json
  def index
    @tales = Tale.list(current_user.id, params[:page])
  end

  # GET /tales/1
  # GET /tales/1.json
  def show
    @sequels = Sequel.list(@tale.id)
    @new_sequel = Sequel.new
  end

  # GET /tales/new
  def new
    @tale = Tale.new
  end

  # GET /tales/1/edit
  def edit
  end

  # POST /tales
  # POST /tales.json
  def create
    Tale.transaction do
      @tale = Tale.instance(tale_params, current_user)
      if @tale.save
        redirect_to @tale, notice: 'Tale was successfully created.'
      else
        set_flash
        render :new
      end
    end
  end

  # PATCH/PUT /tales/1
  # PATCH/PUT /tales/1.json
  def update
    if @tale.update(tale_params)
      redirect_to @tale, notice: 'Tale was successfully updated.'
    else
      set_flash
      render :edit
    end
  end

  # DELETE /tales/1
  # DELETE /tales/1.json
  def destroy
    @tale.destroy
    redirect_to tales_url, notice: 'Tale was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tale
    @tale = Tale.detail(params[:view_number], current_user.id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tale_params
    params.require(:tale).permit(:title, :content)
  end

  # add flash message about error reasons
  def set_flash
    flash.now[:alert] = []
    @tale.errors.full_messages.each { |message| flash.now[:alert] << message + '<br>' }
  end
end
