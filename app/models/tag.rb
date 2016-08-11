class Tag < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_and_belongs_to_many :tales

  # -----------------------------------------------------------------
  # routing path
  # -----------------------------------------------------------------
  # needs three params with request
  # user.id, tag.view_number
  # (user.id + tag.view_number => tag.id)

  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, user)
    tag = Tag.new(params)
    tag.user = user
    tag.view_number = get_view_number(user_id)
    tag
  end

  # support method
  def self.get_view_number(user_id)
    last = Tag.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end

end
