# backup_repository
class BackupRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM backups WHERE user_id = #{user_id} ORDER BY created_at LIMIT 1
  def self.latest(user_id)
    Backup.where('user_id = ?', user_id).order(created_at: :desc).limit(1)
  end
end
