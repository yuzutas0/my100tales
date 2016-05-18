# editor
@my100tales_tales_markdown_editor = (VUE_MARKDOWN_EDITOR_DOM) ->

  # const
  KEY_DOWN = 'keydown'
  KEY_CODE_TAB = 9
  KEY_CODE_SMALL_Z = 90
  TAB_CHAR = '\t'
  NEW_LINE_CHAR = '\n'
  
  # variable
  undoLog = []
  redoLog = []
  
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
      if undoLog.length > 0
        temp = undoLog.pop()
        redoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
        $(VUE_MARKDOWN_EDITOR_DOM).val(temp)
  
    # redo - ctrl + shift + z
    if e.ctrlKey && e.shiftKey && e.keyCode == KEY_CODE_SMALL_Z
      e.preventDefault()
      if redoLog.length > 0
        temp = redoLog.pop()
        undoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
        $(VUE_MARKDOWN_EDITOR_DOM).val(temp)
  
    # save text to undo
    if !e.ctrlKey
      redoLog = []
      if undoLog[undoLog.length - 1] != $(VUE_MARKDOWN_EDITOR_DOM).val()
        undoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
      if undoLog.length >= 20
        undoLog = undoLog.slice(undoLog.length - 20, undoLog.length - 1)