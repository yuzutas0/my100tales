# tale_decorator
class TaleDecorator
  # decide which tab is opened at first view
  def self.tab(params)
    blank = ['', '']
    active = ['active', 'in active']
    result = [blank, blank, blank]
    if params[:sequels].present?
      result[2] = active
    elsif params[:information].present?
      result[1] = active
    else
      result[0] = active
    end
    result
  end

  # add flash message about error reasons
  def self.flash(tale, flash)
    flash.now[:alert] = []
    tale.errors.full_messages.each { |message| flash.now[:alert] << message + '<br>' }
    flash.now[:alert]
  end

  # set option form
  def self.option_form(tale)
    params = {}
    tags = tale.tags.present? ? tale.tags.pluck(:name).join(' ') : ''
    params[:tags] = tags
    TaleForm.new(params)
  end
end
