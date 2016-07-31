# tales/form
@my100tales_tales_form = ->
  
  # const
  VUE_MARKDOWN_ID = 'vue-markdown'
  VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
  VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '-editor'
  VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '-preview'

  SWITCH_MARKDOWN_EDITOR_DOM = '#switch-vue-markdown-editor'
  SWITCH_MARKDOWN_PREVIEW_DOM = '#switch-vue-markdown-preview'
  VUE_MARKDOWN_EDITOR_OUTER_DOM = '#vue-markdown-editor-outer'
  VUE_MARKDOWN_PREVIEW_OUTER_DOM = '#vue-markdown-preview-outer'

  MOBILE_HIDDEN_CLASS = 'hidden-xs'

  # check DOM
  if document.getElementById(VUE_MARKDOWN_ID) != null
    
    # tab
    My100TalesUtilTab.createTab(
      SWITCH_MARKDOWN_EDITOR_DOM,
      SWITCH_MARKDOWN_PREVIEW_DOM,
      VUE_MARKDOWN_EDITOR_OUTER_DOM,
      VUE_MARKDOWN_PREVIEW_OUTER_DOM,
      MOBILE_HIDDEN_CLASS
    )
    
    # markdown
    my100tales_util_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    My100TalesUtilMarkdownPreview.previewMarkdown(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)
