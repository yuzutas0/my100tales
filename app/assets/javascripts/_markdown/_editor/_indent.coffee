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
  
  # check whether there is new line in the text
  existNewLines = (value, position_start, position_end) ->
    return value.substr(position_start, position_end - position_start).indexOf(NEW_LINE_CHAR) != -1

  # check key
  if e.keyCode == KEY_CODE_TAB
    e.preventDefault()

    # set variable
    element = e.target
    value = element.value
    position_start = element.selectionStart
    position_end = element.selectionEnd
    present_line_first = getPresentLineFirst(value, position_start)

    # cursor select one line
    if (position_start == position_end) || (position_start < position_end && !existNewLines(value, position_start, position_end))

      # add indent - tab (without shift key)
      if !e.shiftKey
        element.value = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, value.length)
        element.setSelectionRange(position_start + 1, position_start + 1)

      # delete indent - shift + tab
      if e.shiftKey
        # check whether first character at present line is tab or not
        if value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
          element.value = value.substr(0, present_line_first) + value.substr(present_line_first + TAB_CHAR.length, value.length)
          element.setSelectionRange(position_start - 1, position_start - 1)

    # cursor select some points
    if position_start < position_end && existNewLines(value, position_start, position_end)
      console.log("test")