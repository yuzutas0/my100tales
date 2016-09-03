# sequel_decorator
class TagDecorator < BaseDecorator
  # add flash message about error reasons
  def flash(tag, flash)
    flash_for_redirect(tag, flash)
  end
end
