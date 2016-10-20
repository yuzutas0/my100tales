#
# Association
#
class TaleScoreRelationship < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :tale
  belongs_to :score
  accepts_nested_attributes_for :tale

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :tale_id, presence: true, uniqueness: { scope: [:score_id] }
  validates :tale, presence: true
  validates :score, presence: true

  # -----------------------------------------------------------------
  # elasticsearch
  # -----------------------------------------------------------------
  # include
  include TaleScoreRelationshipSearchable
  # connect
  index_name TaleScoreRelationshipSearchable::INDEX_NAME
  __elasticsearch__.client = TaleScoreRelationshipSearchable::CLIENT
end
