# tale_factory
class TaleFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, user)
    tag = Tag.new(params)
    tag.user = user
    tag.view_number = increment_view_number(user_id)
    tag
  end

  # support method
  def self.increment_view_number(user_id)
    last = Tag.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
