# tales/form
@my100tales_tales_form = ->
  
  # const
  VUE_MARKDOWN_ID = 'script__tale'
  VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
  VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '__editor'
  VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '__preview'

  SWITCH_MARKDOWN_EDITOR_DOM = '#script__tale__editor__tab__switch'
  SWITCH_MARKDOWN_PREVIEW_DOM = '#script__tale__preview__tab__switch'
  VUE_MARKDOWN_EDITOR_OUTER_DOM = '#script__tale__editor__tab__content'
  VUE_MARKDOWN_PREVIEW_OUTER_DOM = '#script__tale__preview__tab__content'
  MOBILE_HIDDEN_CLASS = 'hidden-xs'

  # check DOM
  if document.getElementById(VUE_MARKDOWN_ID) != null
    
    # tab for modal
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
