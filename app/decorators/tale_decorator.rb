# tale_decorator
class TaleDecorator < BaseDecorator
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
    flash_for_render(tale, flash)
  end

  # set option form
  def self.option_form(tale)
    params = {}
    tags = tale.tags.present? ? tale.tags.pluck(:name).join(' ') : ''
    params[:tags] = tags
    TaleForm.new(params)
  end
end
