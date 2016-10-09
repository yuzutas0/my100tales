#
# ApplicationHelper
#
module ApplicationHelper
  # set each page title at html
  def page_title
    title = Constants::PRODUCT_NAME
    title = @page_title + ' - ' + title if @page_title
    title
  end

  # display present lang
  def present_lang
    lang_list.select { |k, v| k == I18n.locale }
  end

  # display another lang list
  def another_lang_list
    lang_list.reject { |k, v| k == I18n.locale }
  end

  # display time converted for each location
  def local_time(obj)
    obj.in_time_zone(@timezone).strftime('%Y-%m-%d %H:%M')
  end

  private

  # available lang list
  def lang_list
    {
        :en => 'English',
        :ja => '日本語'
    }
  end
end
