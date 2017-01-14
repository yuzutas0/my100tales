#
# HomeHelper
#
module HomeHelper
  def i18n_terms_format(html_text)
    regex = /(\nArticle\s\d+\s.+)/ # if I18n.locale == :en
    regex = /(\n第\d+条.+)/ if I18n.locale == :ja
    i18n_text_format(html_text, regex)
  end

  def i18n_privacy_format(html_text)
    regex = /(\n\d+\s.+)/ # if I18n.locale == :en
    regex = /(\n\d+\..+)/ if I18n.locale == :ja
    i18n_text_format(html_text, regex)
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
