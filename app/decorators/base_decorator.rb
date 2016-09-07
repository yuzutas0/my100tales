# common_decorator
class BaseDecorator
  # const
  NEW_LINE_TAG = '<br>'.freeze

  # add flash message about error reasons
  def self.flash_for_redirect(model, flash)
    flash[:alert] = []
    model.errors.full_messages.each { |message| flash[:alert] << message + NEW_LINE_TAG }
    flash[:alert]
  end

  # add flash message about error reasons
  def self.flash_for_render(model, flash)
    flash.now[:alert] = []
    model.errors.full_messages.each { |message| flash.now[:alert] << message + NEW_LINE_TAG }
    flash.now[:alert]
  end
end
