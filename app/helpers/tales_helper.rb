#
# TalesHelper
#
module TalesHelper

  # render from markdown text to html
  def markdown_to_html(text)
    # set param
    extentions = { no_intra_emphasis: true, tables: true, fenced_code_blocks: true, autolink: true, strikethrough: true, lax_html_blocks: true, superscript: true }
    render_options = { filter_html: true, hard_wrap: true }

    # execute rendering
    renderer = Redcarpet::Render::HTML.new(render_options)
    Redcarpet::Markdown.new(renderer, extentions).render(text).html_safe
  end

  # render from markdown text to plain text
  def markdown_to_plain(text)
    strip_tags(simple_format(h(markdown_to_html(text))))
  end
end
