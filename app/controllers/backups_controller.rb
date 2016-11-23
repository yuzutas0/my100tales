#
# BackupsController
#
class BackupsController < ApplicationController
  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  RESPONSE_TYPE = 'application/zip'.freeze

  # -----------------------------------------------------------------
  # endpoint
  # -----------------------------------------------------------------
  # POST /backup
  def download
    filename, zip_data = BackupService.create(current_user)
    send_data(zip_data, type: RESPONSE_TYPE, filename: filename)
  end
end
