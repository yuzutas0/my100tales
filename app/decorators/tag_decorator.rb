# tag_decorator
class TagDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(tag, flash)
    flash_for_redirect(tag, flash)
  end
end
