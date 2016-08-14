#
# Sequel
#
class Sequel < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :tale

  # -----------------------------------------------------------------
  # routing path
  # -----------------------------------------------------------------
  # needs three params with request
  # user.id, tale.view_number, sequel.view_number
  # (user.id + tale.view_number => tale.id) + (sequel.view_number) => sequel.id

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :tale, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
end
