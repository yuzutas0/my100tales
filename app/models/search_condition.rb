#
# SearchCondition
#
class SearchCondition < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user

  # -----------------------------------------------------------------
  # routing path (search_conditions/:id => search_conditions/:view_number)
  # -----------------------------------------------------------------
  # needs two params with request
  # user.id, search_condition.view_number
  # (user.id + search_condition.view_number => search_condition.id)
  def to_param
    view_number.to_s
  end

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, length: { minimum: 0, maximum: 255 }
  validates :query_string, presence: true, length: { minimum: 1, maximum: 1_500 }
  validates :save_flag, inclusion: { in: [true, false] }
  validates :view_number, presence: true, uniqueness: { scope: [:user_id] }
  validates :user, presence: true
end
