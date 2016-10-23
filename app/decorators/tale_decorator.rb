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
  def self.option_form(tale, showing_tags = '')
    params = {}
    params[:tags] = tale_tags_for_form(tale, showing_tags)
    TaleForm.new(params)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    def tale_tags_for_form(tale, showing_tags)
      # top priority
      return showing_tags if showing_tags.present?
      # merge tags and scores
      list = []
      list << tale.tags.pluck(:name) if tale.tags.present?
      list << tale.scores.map { |i| i.key + ':' + i.value } if tale.scores.present?
      list.join(',')
    end
  end
end
