# indent - tab key
@my100tales_tales_markdown_editor_indent = (e) ->

  # const
  KEY_CODE_TAB = 9
  TAB_CHAR = '\t'
  NEW_LINE_CHAR = '\n'

  # calculate the beginning of present line
  getPresentLineFirst = (value, position) ->
    previous_line_last = value.lastIndexOf(NEW_LINE_CHAR, position - 1)
    present_line_first = 0
    if previous_line_last > 0
      present_line_first = previous_line_last + NEW_LINE_CHAR.length
    return present_line_first

  # check key
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
    if e.shiftKey
      # check whether first character at present line is tab or not
      if value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
        element.value = value.substr(0, present_line_first) + value.substr(present_line_first + TAB_CHAR.length, value.length)
        element.setSelectionRange(position - 1, position - 1)
