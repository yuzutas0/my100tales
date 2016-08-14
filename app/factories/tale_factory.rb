# tale_factory
class TaleFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of user_id and view_number unique
  def self.instance(params, user)
    tale = Tale.new(params)
    tale.user = user
    tale.view_number = increment_view_number(user.id)
    tale
  end

  private

  # support method
  def self.increment_view_number(user_id)
    last = Tale.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
