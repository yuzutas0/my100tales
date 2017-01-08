#
# HomeHelper
#
module HomeHelper
  def i18n_terms_format(html_text)
    i18n_text_format(html_text, /(\n第\d+条.+)/)
  end

  def i18n_privacy_format(html_text)
    i18n_text_format(html_text, /(\n\d+\..+)/)
  end

  def i18n_table_format(html_text)
    raw i18n_format html_text
      .gsub(/>(\r\n|\r|\n)/, '>')
      .gsub(/<th>/, '<th><p>')
      .gsub(%r{</th>}, '<p></th>')
      .gsub(/<td>/, '<td><p>')
      .gsub(%r{</td>}, '<p></td>')
  end

  private

  def i18n_text_format(html_text, regex)
    raw '<p>' + i18n_format(html_text.gsub(regex, '<b>\1</b>')) + '</p>'
  end

  def i18n_format(html_text)
    html_text.gsub(/\r\n|\r|\n/, '<br />')
  end
end
