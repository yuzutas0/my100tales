#
# HomeHelper
#
module HomeHelper
  def render_i18n(html_text)
    raw(html_text
            .gsub(/>(\r\n|\r|\n)/, '>')
            .gsub(/<th>/, '<th><p>')
            .gsub(/<\/th>/, '<p></th>')
            .gsub(/<td>/, '<td><p>')
            .gsub(/<\/td>/, '<p></td>')
            .gsub(/\r\n|\r|\n/, '<br />'))
  end
end
