#
# HomeHelper
#
module HomeHelper
  def i18n_terms_format(html_text)
    raw '<p>' + html_text.gsub(/(\n第\d+条.+)/, '<b>\1</b>').gsub(/\r\n|\r|\n/, '<br />') + '</p>'
  end

  def i18n_privacy_format(html_text)
    raw '<p>' + html_text.gsub(/(\n\d+\..+)/, '<b>\1</b>').gsub(/\r\n|\r|\n/, '<br />') + '</p>'
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
