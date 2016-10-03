# search_condition_decorator
class SearchConditionDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(search_condition, flash)
    flash_for_redirect(search_condition, flash)
  end
end
