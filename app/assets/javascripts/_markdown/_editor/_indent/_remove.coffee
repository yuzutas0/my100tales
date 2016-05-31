# add indent - tab key with shift
@my100tales_tales_markdown_editor_indent_remove = (e) ->

  # const
  TAB_CHAR = '\t'
  NEW_LINE_CHAR = '\n'
  NEW_LINE_AND_TAB_REGIX = /\n\t/g

  # calculate the beginning of present line
  getPresentLineFirst = (value, position) ->
    previous_line_last = value.lastIndexOf(NEW_LINE_CHAR, position - 1)
    present_line_first = 0
    if previous_line_last > 0
      present_line_first = previous_line_last + NEW_LINE_CHAR.length
    return present_line_first

  # check whether there is new line in the text
  existNewLines = (value, position_start, position_end) ->
    if position_start == position_end
      return false
    return value.substr(position_start, position_end - position_start).indexOf(NEW_LINE_CHAR) != -1

  # set variable
  element = e.target
  value = element.value
  position_start = element.selectionStart
  position_end = element.selectionEnd
  present_line_first = getPresentLineFirst(value, position_start)

  # check whether first character at present line is tab or not
  if value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
    element.value = value.substr(0, present_line_first) + value.substr(present_line_first + TAB_CHAR.length, value.length - (present_line_first + TAB_CHAR.length))

    # check to avoid that cursor goes previous line's last position
    if present_line_first == position_start && position_start == position_end
      element.setSelectionRange(position_start, position_end)
    else if present_line_first == position_start && position_start != position_end
      element.setSelectionRange(position_start, position_end - 1)
    else
      element.setSelectionRange(position_start - 1, position_end - 1)

  # cursor select some points
  if existNewLines(value, position_start, position_end)

# reset variable
    element = e.target
    value = element.value
    position_start = element.selectionStart
    position_end = element.selectionEnd

    # \n\t => \n (except for last line)
    result_text = value.substr(0, position_start)
    result_text += value.substr(position_start, position_end - position_start).replace(NEW_LINE_AND_TAB_REGIX, NEW_LINE_CHAR)
    result_text += value.substr(position_end, value.length - position_end)
    diff_count = value.substr(position_start, position_end - position_start).split(NEW_LINE_CHAR + TAB_CHAR).length - 1

    # set DOM
    element.value = result_text
    element.setSelectionRange(position_start, position_end - diff_count)
