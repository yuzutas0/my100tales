#
# BackupsController
#
class BackupsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_backup, only: [:download, :create]

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /backup
  def index
  end

  # GET /backup/download
  def download
    # todo: implement
  end

  # -----------------------------------------------------------------
  # endpoint - create or update
  # -----------------------------------------------------------------
  # POST /backup
  def create
    # todo: implement
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_backup
    @backup = nil # todo: implement with current_user.id
    routing_error if @backup.blank?
  end
end
