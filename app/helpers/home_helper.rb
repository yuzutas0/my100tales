#
# HomeHelper
#
module HomeHelper
  def i18n_text_format(html_text)
    raw '<p>' + html_text.gsub(/(\d+\..+)/, '<b>\1</b>').gsub(/\r\n|\r|\n/, '<br />') + '</p>'
  end

  def i18n_table_format(html_text)
    raw html_text
            .gsub(/>(\r\n|\r|\n)/, '>')
            .gsub(/<th>/, '<th><p>')
            .gsub(/<\/th>/, '<p></th>')
            .gsub(/<td>/, '<td><p>')
            .gsub(/<\/td>/, '<p></td>')
            .gsub(/\r\n|\r|\n/, '<br />')
  end
end
