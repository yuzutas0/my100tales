#
# Backup
#
class Backup < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :filename, presence: true, uniqueness: true
  validates :user, presence: true
end
