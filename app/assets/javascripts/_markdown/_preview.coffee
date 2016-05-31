# preview
@my100tales_tales_markdown_preview = (VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM) ->

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

  # bind data by Vue.js
  new Vue(
    el: VUE_MARKDOWN_DOM
    data:
      content: $(VUE_MARKDOWN_EDITOR_DOM).val()
    filters:
      preview: (content) ->
        markdownToHtml(content)
  )

  # TODO: don't use pixel!!! use percentage!!!
  # synchronous scroll - editor => preview
  $(VUE_MARKDOWN_EDITOR_DOM).scroll ->
    top = $(VUE_MARKDOWN_EDITOR_DOM).scrollTop()
    $(VUE_MARKDOWN_PREVIEW_DOM).scrollTop(top)
  # synchronous scroll - preview => editor
  $(VUE_MARKDOWN_PREVIEW_DOM).scroll ->
    top = $(VUE_MARKDOWN_PREVIEW_DOM).scrollTop()
    $(VUE_MARKDOWN_EDITOR_DOM).scrollTop(top)
