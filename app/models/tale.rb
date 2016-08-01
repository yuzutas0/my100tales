#
# Tale
#
class Tale < ActiveRecord::Base

  # include
  include TaleSearchable

  # relation
  belongs_to :user
  has_many :sequels, dependent: :destroy
  has_and_belongs_to_many :tags

  # routing path (tales/:id => tales/:view_number)
  def to_param
    view_number.to_s
  end

  # validation
  validates :user, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 15_000 }

  # Create

  # use transaction to save record if you call this method
  # in order to make combination of user_id and view_number unique
  def self.instance(params, user)
    tale = Tale.new(params)
    tale.user = user
    tale.view_number = get_view_number(user.id)
    tale
  end

  # Read

  def self.list(user_id, page)
    Tale.where('user_id = ?', user_id).page(page).per(10).order(updated_at: :desc)
  end

  def self.detail(view_number, user_id)
    Tale.where('view_number = ? AND user_id = ?', view_number, user_id).first
  end

  # support method
  def self.get_view_number(user_id)
    last = Tale.where('user_id = ?', user_id).maximum(:view_number)
    last = last.present? ? last : 0
    last + 1
  end
end
