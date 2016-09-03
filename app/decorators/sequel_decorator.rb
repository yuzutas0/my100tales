# sequel_decorator
class SequelDecorator < BaseDecorator
  # add flash message about error reasons
  def flash(sequel, flash)
    flash_for_redirect(sequel, flash)
  end
end
