# switch tab editor/preview for smart device
@my100tales_tales_markdown_tab = ->

  # const
  SWITCH_MARKDOWN_EDITOR_DOM = '#switch-vue-markdown-editor'
  SWITCH_MARKDOWN_PREVIEW_DOM = '#switch-vue-markdown-preview'
  VUE_MARKDOWN_EDITOR_OUTER_DOM = '#vue-markdown-editor-outer'
  VUE_MARKDOWN_PREVIEW_OUTER_DOM = '#vue-markdown-preview-outer'
  HIDDEN_CLASS = 'hidden-xs'
  CLICK = 'click'
  
  # TODO: jQuery#xxxClass -> Vue.js
  
  # display both
  displayBothEditorAndPreview =->
    $(VUE_MARKDOWN_EDITOR_OUTER_DOM).removeClass(HIDDEN_CLASS)
    $(VUE_MARKDOWN_PREVIEW_OUTER_DOM).removeClass(HIDDEN_CLASS)
  
  # display editor
  $(SWITCH_MARKDOWN_EDITOR_DOM).on CLICK, ->
    displayBothEditorAndPreview()
    $(VUE_MARKDOWN_PREVIEW_OUTER_DOM).addClass(HIDDEN_CLASS)
  
  # display preview
  $(SWITCH_MARKDOWN_PREVIEW_DOM).on CLICK, ->
    displayBothEditorAndPreview()
    $(VUE_MARKDOWN_EDITOR_OUTER_DOM).addClass(HIDDEN_CLASS)
