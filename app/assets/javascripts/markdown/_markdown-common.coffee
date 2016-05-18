# common
@my100tales_tales_markdown_common = ->

  # const
  VUE_MARKDOWN_ID = 'vue-markdown'
  VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
  VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '-editor'
  VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '-preview'

  # check DOM
  if document.getElementById(VUE_MARKDOWN_ID) != null
    my100tales_tales_markdown_tab()
    my100tales_tales_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    my100tales_tales_markdown_preview(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)
