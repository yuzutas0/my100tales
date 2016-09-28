#
# SearchCondition
#
class SearchCondition < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, length: { minimum: 1, maximum: 255 }
  validates :query_string, length: { minimum: 1, maximum: 1_500 }, presence: true
  validates :save_flag, inclusion: { in: [true, false] }
  validates :user, presence: true
end
