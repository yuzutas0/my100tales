# editor
@my100tales_util_markdown_editor = (VUE_MARKDOWN_EDITOR_DOM) ->

  # const
  KEY_DOWN = 'keydown'
  
  # control key bind for markdown editor
  $(VUE_MARKDOWN_EDITOR_DOM).bind KEY_DOWN, (e) ->
    my100tales_util_markdown_editor_indent(e)
    my100tales_util_markdown_editor_list(e)
    my100tales_util_markdown_editor_undo(e, VUE_MARKDOWN_EDITOR_DOM)
