# tale_decorator
class TaleDecorator
  # decide which tab is opened at first view
  def self.tab(params)
    if params[:sequels].present?
      [['', ''], ['', ''], ['active', 'in active']]
    else
      [['active', 'in active'], ['', ''], ['', '']]
    end
  end

  # add flash message about error reasons
  def self.flash(tale)
    flash.now[:alert] = []
    tale.errors.full_messages.each { |message| flash.now[:alert] << message + '<br>' }
    flash.now[:alert]
  end
end
