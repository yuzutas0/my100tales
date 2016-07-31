# sequels/edit
@my100tales_sequels_edit = ->

  # loop for sequel index length - 0 for new
  index = -1
  while true
    index++

    # const
    VUE_EDIT_ID = "vue__sequel__index--" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID

    # check DOM
    if document.getElementById(VUE_EDIT_ID) == null
      break

    # modal
    @My100TalesUtilModal.create_modal(VUE_EDIT_DOM)

    # markdown
    # const
    VUE_MARKDOWN_ID = 'vue-markdown-' + index
    VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
    VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '-editor'
    VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '-preview'

    # check DOM
    if document.getElementById(VUE_MARKDOWN_ID) != null
      my100tales_tales_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
      my100tales_tales_markdown_preview(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)
