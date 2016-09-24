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
  # elasticsearch
  # -----------------------------------------------------------------
  # include
  include TaleTagRelationshipSearchable
  # connect
  index_name TaleTagRelationshipSearchable::INDEX_NAME
  __elasticsearch__.client = TaleTagRelationshipSearchable::CLIENT
end
