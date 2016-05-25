# add indent - tab key without shift
@my100tales_tales_markdown_editor_indent_add = (e) ->

# const
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
    if position_start == position_end
      return false
    return value.substr(position_start, position_end - position_start).indexOf(NEW_LINE_CHAR) != -1

  # set variable
  element = e.target
  value = element.value
  position_start = element.selectionStart
  position_end = element.selectionEnd
  present_line_first = getPresentLineFirst(value, position_start)

  # add indent - tab (without shift key)
  element.value = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, value.length - present_line_first)
  element.setSelectionRange(position_start + 1, position_end + 1)

  # cursor select some points
  if existNewLines(value, position_start, position_end)

    # reset variable
    element = e.target
    value = element.value
    position_start = element.selectionStart
    position_end = element.selectionEnd

    # ready for loop
    count = 0
    result_text = value.substr(0, position_start)
    text_list = value.substr(position_start, position_end - position_start).split(NEW_LINE_CHAR)

    # loop
    for text in text_list
      result_text += text

      # \n => \n\t (except for last line)
      if text_list.length - 1 != count
        result_text += NEW_LINE_CHAR + TAB_CHAR
        count++

      # check to avoid that cursor goes next line's first position
      if text_list.length - 1 == count && text == ''
        result_text = result_text.substr(0, result_text.length - TAB_CHAR.length)
        count -= 2

    # set DOM
    element.value = result_text + value.substr(position_end, value.length - position_end)
    element.setSelectionRange(position_start, position_end + count)
