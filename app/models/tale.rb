class Tale < ActiveRecord::Base
  # relation
  belongs_to :user

  # routing path
  def to_param
    "#{view_number}"
  end

  # validation
  validates :title, presence: true, length: {minimum: 1}
  validates :content, presence: true, length: {minimum: 1}

  # CRUD
  def self.instance(params, user)
    tale = Tale.new(params)
    tale.user = user
    tale.view_number = get_view_number(user.id)
    return tale
  end

  def self.list(user_id)
    Tale.where("user_id = ?", user_id).order(updated_at: :desc)
  end

  def self.detail(view_number, user_id)
    Tale.where("view_number = ? AND user_id = ?", view_number, user_id).first
  end

  # support method
  private
    def self.get_view_number(user_id)
      last = Tale.where("user_id = ?", user_id).maximum(:view_number)
      last = last.present? ? last : 0
      return last + 1
    end
end
