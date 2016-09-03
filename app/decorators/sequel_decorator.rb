# sequel_decorator
class SequelDecorator < CommonDecorator
  # add flash message about error reasons
  def flash(sequel, flash)
    flash_for_redirect(sequel, flash)
  end
end
