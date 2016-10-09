#
# DeviseHelper
#
module DeviseHelper
  def default_timezone
    present_lang.keys.first == :ja ? 'Asia/Tokyo' : 'Etc/GMT'
  end

  def devise_error_messages!
    return '' if resource.errors.empty?
    flash.now[:alert] = []
    resource.errors.full_messages.each { |message| flash.now[:alert] << message + '.<br>' }
    ''
  end
end
