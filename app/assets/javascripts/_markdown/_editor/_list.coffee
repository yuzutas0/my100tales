# list suggestion
@my100tales_tales_markdown_editor_list = (e) ->

  # const
  KEY_CODE_ENTER = 13
  NEW_LINE_CHAR = '\n'
  TAB_CHAR = '\t'
  NOT_NUMBER_LIST_STYLE_ONE = '*'
  NOT_NUMBER_LIST_STYLE_TWO = '-'
  NUMBER_LIST_SUFFIX = '.'
  WHITE_SPACE = ' '

  # example
  # "- "
  # "- test"
  # "  * "
  # "  * test"
  # "    1. "
  # "    2. test"
  LIST_REGEX = /(\t|\s{2})*(-|\*|\d\.)\s.+/

  # calculate the beginning of present line
  getPresentLineFirst = (value, position) ->
    previous_line_last = value.lastIndexOf(NEW_LINE_CHAR, position - 1)
    present_line_first = 0
    if previous_line_last > 0
      present_line_first = previous_line_last + NEW_LINE_CHAR.length
    return present_line_first

  # check key
  if e.keyCode == KEY_CODE_ENTER

    # set variable
    element = e.target
    value = element.value
    position_start = element.selectionStart
    position_end = element.selectionEnd

    # delete contents selected
    if position_start < position_end
      element.value = value.substr(0, position_start) + value.substr(position_end, value.length - position_end)
      element.setSelectionRange(position_start, position_start)

      # reset variable
      element = e.target
      value = element.value
      position_start = element.selectionStart

    # ready for suggestion
    suggestion = ''

    # ready for check
    present_line_first = getPresentLineFirst(value, position_start)
    previous_contents = value.substr(present_line_first, position_start - present_line_first)

    # check whether there is list to suggest
    if LIST_REGEX.test(previous_contents)
      e.preventDefault()

      # count tab
      tab_count = 0
      while previous_contents[tab_count] == TAB_CHAR
        if previous_contents[tab_count] == TAB_CHAR
          suggestion += TAB_CHAR
          tab_count++

      # check list style
      previous_contents = previous_contents.substr(tab_count, previous_contents.length - tab_count)

      # case '*' or '-' => use the same character
      if previous_contents[0] == NOT_NUMBER_LIST_STYLE_ONE || previous_contents[0] == NOT_NUMBER_LIST_STYLE_TWO
        suggestion += previous_contents[0]

      # case '1.', '2.', ... => use the incremented number
      else if previous_contents.indexOf(NUMBER_LIST_SUFFIX) > 0
        console.log(previous_contents.indexOf(NUMBER_LIST_SUFFIX).toString())
        present_list_number_string = previous_contents.substr(0, previous_contents.indexOf(NUMBER_LIST_SUFFIX))
        console.log(present_list_number_string)
        next_list_number = Number(present_list_number_string) + 1
        console.log(next_list_number.toString())
        suggestion += next_list_number + NUMBER_LIST_SUFFIX

      # add white space
      suggestion += WHITE_SPACE

      # update content
      element.value = value.substr(0, position_start) + NEW_LINE_CHAR + suggestion + value.substr(position_start, value.length - position_start)
      element.setSelectionRange(position_start + suggestion.length + 1, position_start + suggestion.length + 1)
