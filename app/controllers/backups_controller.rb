#
# BackupsController
#
class BackupsController < ApplicationController
  # -----------------------------------------------------------------
  # Filter
  # -----------------------------------------------------------------
  # before_action :set_backup

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  RESPONSE_TYPE = 'application/zip'.freeze

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /backup
  def index
  end

  # GET /backup
  def download
    filename, zip_data = BackupService.create(current_user)
    send_data(zip_data, type: RESPONSE_TYPE, filename: filename)
  end

  # -----------------------------------------------------------------
  # endpoint - create or update
  # -----------------------------------------------------------------
  # POST /backup
  def create
    # todo: implement
    # validate when the user is creating file
    # BackupService.create(current_user.id)
    # flash[:notice] = t('views.message.create.doing')
    # redirect_to backups_path
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
