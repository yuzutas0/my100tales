# backup_service
class BackupService
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.read(user_id)
    BackupRepository.latest(user_id)
  end
end
