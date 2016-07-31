#
# TalesHelper
#
module TalesHelper
  # render from markdown text to html
  def markdown_to_html(text)
    # set param
    extentions = {
      autolink: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      footnotes: true,
      highlight: true,
      no_intra_emphasis: true,
      quote: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      lax_html_blocks: true
    }
    render_options = {
      filter_html: true,
      hard_wrap: true
    }

    # execute rendering
    renderer = Redcarpet::Render::HTML.new(render_options)
    emojify(Redcarpet::Markdown.new(renderer, extentions).render(text).html_safe)
  end

  # render from markdown text to plain text
  def markdown_to_plain(text)
    strip_tags(simple_format(h(markdown_to_html(text))))
  end

  # render emoji-markdown to illustration
  # copy from gemoji's readme
  def emojify(content)
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias(Regexp.last_match(1))
        %(<img alt="#{Regexp.last_match(1)}" src="#{asset_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end
end
