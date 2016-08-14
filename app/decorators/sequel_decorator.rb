# sequel_decorator
class SequelDecorator
  # add flash message about error reasons
  def flash(sequel, flash)
    flash[:alert] = []
    sequel.errors.full_messages.each { |message| flash[:alert] << message + '<br>' }
    flash[:alert]
  end
end
