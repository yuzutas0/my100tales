#
# BackupsController
#
class BackupsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_backup

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /backup
  def index
  end

  # GET /backup/download
  def download
    routing_error if @backup.blank?
    # todo: implement
  end

  # -----------------------------------------------------------------
  # endpoint - create or update
  # -----------------------------------------------------------------
  # POST /backup
  def create
    # todo: implement
    # validate when the user is creating file
    flash[:notice] = t('views.message.create.doing')
    redirect_to backups_path
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_backup
    @backup = BackupService.read(current_user.id)
  end
end
