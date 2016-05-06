#
# TalesHelper
#
module TalesHelper
  def markdown(text)
    # set param
    extentions = { tables: true, fenced_code_blocks: true }
    render_options = { filter_html: true, hard_wrap: true }

    # execute rendering
    renderer = Redcarpet::Render::HTML.new(render_options)
    Redcarpet::Markdown.new(renderer, extentions).render(text).html_safe
  end
end
