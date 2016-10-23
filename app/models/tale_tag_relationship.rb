#
# Association
#
class TaleTagRelationship < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :tale
  belongs_to :tag
  accepts_nested_attributes_for :tale

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :tale_id, presence: true, uniqueness: { scope: [:tag_id] }
  validates :tale, presence: true
  validates :tag, presence: true
end
