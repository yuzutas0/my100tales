# sequel_repository
class SequelRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  def self.list(tale_id)
    Sequel.where('tale_id = ?', tale_id)
          .order(view_number: :desc)
  end
end
