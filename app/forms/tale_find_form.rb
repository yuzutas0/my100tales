#
# Tale Find Form
#
class TaleFindForm
  include ActiveModel::Model

  attr_accessor :keyword
  validates :keyword, presence: true
end
