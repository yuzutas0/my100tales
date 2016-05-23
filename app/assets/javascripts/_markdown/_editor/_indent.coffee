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
    if position_start == position_end
      return false
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
    if !existNewLines(value, position_start, position_end)

      # add indent - tab (without shift key)
      if !e.shiftKey
        element.value = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, value.length - present_line_first)
        element.setSelectionRange(position_start + 1, position_end + 1)

      # delete indent - shift + tab
      if e.shiftKey
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

    # cursor select some points TODO: fix bug!!!!!
    if existNewLines(value, position_start, position_end)

      # add indent - tab (without shift key)
      if !e.shiftKey
        # first line
        result_text = value.substr(0, present_line_first) + TAB_CHAR + value.substr(present_line_first, position_start - present_line_first)
        # ready for loop
        count = 0
        text_list = value.substr(position_start, position_end - position_start).split(NEW_LINE_CHAR)
        # new line => new line + tab (except for last line)
        for text in text_list
          result_text += text
          count++
          if text_list.length != count
            result_text += NEW_LINE_CHAR + TAB_CHAR
        # set DOM
        element.value = result_text + value.substr(position_end, value.length - position_end)
        element.setSelectionRange(position_start + 1, position_end + count)

      # delete indent - shift + tab
      if e.shiftKey
        # first line
        result_text = value.substr(0, present_line_first)
        # first line : check whether first character at present line is tab or not
        if value.indexOf(TAB_CHAR, present_line_first) - present_line_first == 0
          result_text += value.substr(present_line_first + TAB_CHAR.length, position_start - (present_line_first + TAB_CHAR.length))
          first_line_indent_decrement = true
        else
          result_text += value.substr(present_line_first, position_start - present_line_first)
          first_line_indent_decrement = false
      # ready for loop
      count = 0
      text_list = value.substr(position_start, position_end - position_start).split(NEW_LINE_CHAR + TAB_CHAR)
      # loop
      for text in text_list
        result_text += text
        if text_list.length - 1 != count
          result_text += NEW_LINE_CHAR
          count++
      # calculate position end
      if first_line_indent_decrement
        count++
      # set DOM
      element.value = result_text + value.substr(position_end, value.length - position_end)
      # check to avoid that cursor goes previous line's last position
      if present_line_first == position_start
        element.setSelectionRange(position_start, position_end - count)
      else if present_line_first != position_start && first_line_indent_decrement
        element.setSelectionRange(position_start - 1, position_end - count)
      else
        element.setSelectionRange(position_start, position_end - count)
