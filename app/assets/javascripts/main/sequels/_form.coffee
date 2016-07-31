# sequels/form
@my100tales_sequels_form = ->

  # loop for sequel index length - 0 for new
  index = -1
  while true
    index++

    # DOM
    # const
    VUE_EDIT_ID = "vue__sequel__index--" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID
    # check
    if document.getElementById(VUE_EDIT_ID) == null
      break

    # switch
    # const
    SWITCH_MARKDOWN_EDITOR_DOM = "#script__sequel__" + index + "__editor__tab__switch"
    SWITCH_MARKDOWN_PREVIEW_DOM = "#script__sequel__" + index + "__preview__tab__switch"
    VUE_MARKDOWN_EDITOR_OUTER_DOM = "#script__sequel__" + index + "__editor__tab__content"
    VUE_MARKDOWN_PREVIEW_OUTER_DOM = "#script__sequel__" + index + "__preview__tab__content"
    HIDDEN_CLASS = 'hidden'
    # render
    My100TalesUtilTab.createTab(
      SWITCH_MARKDOWN_EDITOR_DOM,
      SWITCH_MARKDOWN_PREVIEW_DOM,
      VUE_MARKDOWN_EDITOR_OUTER_DOM,
      VUE_MARKDOWN_PREVIEW_OUTER_DOM,
      HIDDEN_CLASS
    )

    # markdown
    # const
    VUE_MARKDOWN_ID = 'vue-markdown-' + index
    VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
    VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '-editor'
    VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '-preview'
    # render
    editor = my100tales_util_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    preview = My100TalesUtilMarkdownPreview.previewMarkdown(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)

    # modal
    @My100TalesUtilModal.createModal(VUE_EDIT_DOM, editor, preview)
