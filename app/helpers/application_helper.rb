#
# ApplicationHelper
#
module ApplicationHelper
  # -----------------------------------------------------------------
  # page title
  # -----------------------------------------------------------------
  def page_title
    title = Constants::PRODUCT_NAME_FOR_TITLE
    title = @page_title + ' - ' + title if @page_title
    title
  end

  # -----------------------------------------------------------------
  # lang
  # -----------------------------------------------------------------
  def present_lang
    lang_list.select { |k, _v| k == I18n.locale }
  end

  def another_lang_list
    lang_list.reject { |k, _v| k == I18n.locale }
  end

  # -----------------------------------------------------------------
  # time
  # -----------------------------------------------------------------
  def local_time(time)
    # p current_user.id if user_signed_in?
    timezone = 'Asia/Tokyo'
    time.in_time_zone(timezone).strftime('%Y-%m-%d %H:%M')
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  private

  def lang_list
    {
      en: 'English',
      ja: '日本語'
    }
  end
end
