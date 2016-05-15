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
    VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '-preview';
    KEY_DOWN = 'keydown'
    KEY_CODE_TAB = 9
    KEY_CODE_SMALL_Z = 90
    TAB_CHAR = '\t'
    NEW_LINE_CHAR = '\n'

    # variable
    stringUndo = []
    stringRedo = []

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

      # indent - tab key
      if e.keyCode == KEY_CODE_TAB
        e.preventDefault()

        # set variable
        element = e.target
        value = element.value
        position = element.selectionStart
        present_line_first = getPresentLineFirst(value, position)

        # add indent - tab (without shift key)
        if !e.shiftKey
          element.value = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, value.length)
          element.setSelectionRange(position + 1, position + 1)

        # delete indent - shift + tab
        if e.shiftKey && value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
          element.value = value.substr(0, present_line_first) + value.substr(present_line_first + TAB_CHAR.length, value.length)
          element.setSelectionRange(position - 1, position - 1)

      # undo - ctrl + z (without shift key)
      if e.ctrlKey && !e.shiftKey && e.keyCode == KEY_CODE_SMALL_Z
        e.preventDefault()
        if stringUndo.length > 0
          temp = stringUndo.pop()
          stringRedo.push $(VUE_MARKDOWN_EDITOR_DOM).val()
          $(VUE_MARKDOWN_EDITOR_DOM).val(temp)

      # redo - ctrl + shift + z
      if e.ctrlKey && e.shiftKey && e.keyCode == KEY_CODE_SMALL_Z
        e.preventDefault()
        if stringRedo.length > 0
          temp = stringRedo.pop()
          stringUndo.push $(VUE_MARKDOWN_EDITOR_DOM).val()
          $(VUE_MARKDOWN_EDITOR_DOM).val(temp)

      # save text to undo
      if !e.ctrlKey
        stringRedo = []
        stringUndo.push $(VUE_MARKDOWN_EDITOR_DOM).val()

    # synchronous scroll - editor => preview
    $(VUE_MARKDOWN_EDITOR_DOM).scroll ->
      top = $(VUE_MARKDOWN_EDITOR_DOM).scrollTop()
      $(VUE_MARKDOWN_PREVIEW_DOM).scrollTop(top)

    # synchronous scroll - preview => editor
    $(VUE_MARKDOWN_PREVIEW_DOM).scroll ->
      top = $(VUE_MARKDOWN_PREVIEW_DOM).scrollTop()
      $(VUE_MARKDOWN_EDITOR_DOM).scrollTop(top)

  return

# execute with RubyGem 'turbolinks'
$(document).ready(ready)
$(document).on('page:load', ready)
