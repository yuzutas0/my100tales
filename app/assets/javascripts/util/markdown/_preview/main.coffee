# util/markdown/preview
class @My100TalesUtilMarkdownPreview

  # const
  NEW_LINE_CHAR = '\n'
  NEW_LINE_REGEX = /\n/g
  WHITE_SPACE_CHAR = ' '
  NEW_LINE_CHAR_FOR_MARKDOWN = WHITE_SPACE_CHAR + WHITE_SPACE_CHAR + NEW_LINE_CHAR

  # render from markdown to html
  # reference https://www.npmjs.com/browse/keyword/markdown-it-plugin
  markdownToHtml = (content) ->
    content_customized = content.replace(NEW_LINE_REGEX, NEW_LINE_CHAR_FOR_MARKDOWN)
    window.markdownit({ linkify: true })
    .use(window.markdownitEmoji)
    .use(window.markdownitFootnote)
    .use(window.markdownitSup)
    .render(DOMPurify.sanitize(content_customized))
  
  # scroll both display
  scroll = (editorDom, previewDom) ->
    # TODO: don't use pixel!!! use percentage!!!
    # synchronous scroll - editor => preview
    $(editorDom).scroll ->
      top = $(editorDom).scrollTop()
      $(previewDom).scrollTop(top)
    # synchronous scroll - preview => editor
    $(previewDom).scroll ->
      top = $(previewDom).scrollTop()
      $(editorDom).scrollTop(top)

  # preview
  @previewMarkdown = (editorDom, previewDom, vueDom) ->
    # bind data by Vue.js
    Vue.config.devtools = false
    new Vue(
      el: vueDom
      data:
        content: $(editorDom).val()
      filters:
        preview: (content) ->
          markdownToHtml(content)
    )
    # scroll
    scroll(editorDom, previewDom)
