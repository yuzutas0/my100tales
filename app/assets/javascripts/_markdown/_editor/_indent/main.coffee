# indent - tab key
@my100tales_tales_markdown_editor_indent = (e) ->

  # const
  @KEY_CODE_TAB = 9

  # check key
  if e.keyCode == KEY_CODE_TAB
    e.preventDefault()

    if !e.shiftKey
      my100tales_tales_markdown_editor_indent_add(e)
    if e.shiftKey
      my100tales_tales_markdown_editor_indent_remove(e)
