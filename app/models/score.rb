#
# Score
#
class Score < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :tale_score_relationships, dependent: destroy
  has_many :tales, through: :tale_score_relationships

  # -----------------------------------------------------------------
  # routing path (scores/:id => scores/:view_number)
  # -----------------------------------------------------------------
  # needs two params with request
  # user.id, score.view_number
  # (user.id + score.view_number => score.id)
  def to_param
    view_number.to_s
  end

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :key,
            presence: true,
            length: { minimum: 1, maximum: 100 },
            uniqueness: { scope: [:value, :user_id] }

  validates :value,
            presence: true,
            length: { minimum: 1, maximum: 100 }

  validates :view_number,
            presence: true,
            uniqueness: { scope: [:user_id] },
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :user,
            presence: true
end
