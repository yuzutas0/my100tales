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

  def root_path_list
    lang_list.keys.map(&:to_s).each { |k| k.insert(0, '/') }.push('/')
  end

  # -----------------------------------------------------------------
  # time
  # -----------------------------------------------------------------
  def local_time(time)
    time.in_time_zone(user_timezone).strftime('%Y-%m-%d %H:%M')
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

  def user_timezone
    tz = current_user.timezone
    tz = user_signed_in? && right_timezone?(tz) ? tz : 'Etc/GMT'
    TZInfo::Timezone.get(tz).identifier
  end

  def right_timezone?(timezone)
    TZInfo::Timezone.all_identifiers.include?(timezone)
  end
end
