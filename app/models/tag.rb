class Tag < ActiveRecord::Base
  # relation
  has_and_belongs_to_many :tales
end
