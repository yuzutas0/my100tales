# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # check DOM
  VUE_MARKDOWN_ID = 'vue-markdown';
  if document.getElementById(VUE_MARKDOWN_ID) != null

    # const
    VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID;
    VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '-editor';
    KEY_DOWN = 'keydown'
    KEY_CODE_TAB = 9
    TAB_CHAR = '\t'
    NEW_LINE_CHAR = '\n'

    # render from markdown to html
    markdownToHtml = (content) ->
      window.markdownit({ linkify: true })
        .use(window.markdownitEmoji)
        .use(window.markdownitFootnote)
        .use(window.markdownitSup)
        .render(DOMPurify.sanitize(content))

    # bind data by Vue.js
    new Vue(
      el: VUE_MARKDOWN_DOM
      data:
        content: $(VUE_MARKDOWN_EDITOR_DOM).val()
      filters:
        preview: (content) ->
          markdownToHtml(content)
    )

    # calculate the beginning of present line
    getPresentLineFirst = (value, position) ->
      prevent_line_last = value.lastIndexOf(NEW_LINE_CHAR, position - 1)
      present_line_first = 0
      if prevent_line_last > 0
        present_line_first = prevent_line_last + NEW_LINE_CHAR.length
      return present_line_first

    # control key bind for markdown editor
    $(VUE_MARKDOWN_EDITOR_DOM).bind KEY_DOWN, (e) ->
      if e.keyCode == KEY_CODE_TAB
        e.preventDefault()

        # set variable
        element = e.target
        value = element.value
        position = element.selectionStart
        present_line_first = getPresentLineFirst(value, position)

        # enable to add indent by tab key without shift key
        if !e.shiftKey
          element.value = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, value.length)
          element.setSelectionRange(position + 1, position + 1)

        # enable to delete indent by shift + tab key
        if e.shiftKey && value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
          element.value = value.substr(0, present_line_first) + value.substr(present_line_first + TAB_CHAR.length, value.length)
          element.setSelectionRange(position - 1, position - 1)

  return

# execute with RubyGem 'turbolinks'
$(document).ready(ready)
$(document).on('page:load', ready)
