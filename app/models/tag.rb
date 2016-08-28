#
# Tag
#
class Tag < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :tale_tag_relationships
  has_many :tales, through: :tale_tag_relationships

  # -----------------------------------------------------------------
  # routing path
  # -----------------------------------------------------------------
  # needs three params with request
  # user.id, tag.view_number
  # (user.id + tag.view_number => tag.id)

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :user, presence: true
  validates :name, presence: true, length: { maximum: 100 }
end
