#
# Association
#
class TaleTagRelationship < ActiveRecord::Base
  belongs_to :tale
  belongs_to :tag
end
