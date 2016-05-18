# undo and redo - ctrl + z key
@my100tales_tales_markdown_editor_undo = (e, VUE_MARKDOWN_EDITOR_DOM) ->

  # const
  KEY_CODE_SMALL_Z = 90
  UNDO_LOG_SIZE = 20

  # variable
  undoLog = []
  redoLog = []

  # save text to undo
  if !e.ctrlKey || !e.keyCode == KEY_CODE_SMALL_Z
    redoLog = []
    if undoLog[undoLog.length - 1] != $(VUE_MARKDOWN_EDITOR_DOM).val()
      undoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
    if undoLog.length >= UNDO_LOG_SIZE
      undoLog = undoLog.slice(undoLog.length - UNDO_LOG_SIZE, undoLog.length - 1)

  # not save text to undo
  if e.ctrlKey && e.keyCode == KEY_CODE_SMALL_Z
    e.preventDefault()

    # undo - ctrl + z (without shift key)
    if !e.shiftKey && undoLog.length > 0
      temp = undoLog.pop()['text']
      redoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
      $(VUE_MARKDOWN_EDITOR_DOM).val(temp)

    # redo - ctrl + shift + z
    if e.shiftKey && redoLog.length > 0
      temp = redoLog.pop()
      undoLog.push $(VUE_MARKDOWN_EDITOR_DOM).val()
      $(VUE_MARKDOWN_EDITOR_DOM).val(temp)
