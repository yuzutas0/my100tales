#
# Sequel
#
class Sequel < ActiveRecord::Base
  # relation
  belongs_to :tale

  # routing path
  # needs three params with request
  # user.id, tale.view_number, sequel.view_number
  # (user.id + tale.view_number => tale.id) + (sequel.view_number) => sequel.id

  # validation
  validates :tale, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }

  # Create

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, tale)
    sequel = tale.sequels.build(params)
    sequel.view_number = get_view_number(tale.id)
    sequel
  end

  # Read
  def self.list(tale_id)
    Sequel.where('tale_id = ?', tale_id).order(created_at: :desc)
  end

  # support method
  def self.get_view_number(tale_id)
    last = Sequel.where('tale_id = ?', tale_id).maximum(:view_number)
    last = last.present? ? last : 0
    last + 1
  end
end
