# tale_decorator
class TaleDecorator < BaseDecorator
  # -----------------------------------------------------------------
  # Common
  # -----------------------------------------------------------------

  # add flash message about error reasons
  def self.flash(tale, flash)
    flash_for_render(tale, flash)
  end

  # -----------------------------------------------------------------
  # Show
  # -----------------------------------------------------------------

  # decide which tab is opened at first view
  # e.g. [ ['',''], ['',''], ['active','in active'] ]
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

  # -----------------------------------------------------------------
  # Form
  # -----------------------------------------------------------------

  # set option form
  def self.option_form(tale, tags = '')
    tale_tags = ''
    tale_tags += tale.tags.pluck(:name).join(',') if tale.tags.present?
    tale_tags += ',' if tale.tags.present? && tags.present?
    tale_tags += tags if tags.present?
    params = {}
    params[:tags] = tale_tags
    TaleForm.new(params)
  end
end
