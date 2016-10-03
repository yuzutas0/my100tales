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

  # -----------------------------------------------------------------
  # elasticsearch
  # -----------------------------------------------------------------
  # include
  include TaleTagRelationshipSearchable
  # connect
  index_name TaleTagRelationshipSearchable::INDEX_NAME
  __elasticsearch__.client = TaleTagRelationshipSearchable::CLIENT
end
