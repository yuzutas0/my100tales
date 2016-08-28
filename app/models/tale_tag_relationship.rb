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
end
