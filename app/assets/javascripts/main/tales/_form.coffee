# tales/form
@my100tales_tales_form = ->

  # ---------------------------------------------------------------------
  # const and function
  # ---------------------------------------------------------------------

  # markdown preview
  VUE_MARKDOWN_ID = 'script__tale'
  VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
  VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '__editor'
  VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '__preview'

  # tab for mobile
  SWITCH_MARKDOWN_EDITOR_DOM = '#script__tale__editor__tab__switch'
  SWITCH_MARKDOWN_PREVIEW_DOM = '#script__tale__preview__tab__switch'
  VUE_MARKDOWN_EDITOR_OUTER_DOM = '#script__tale__editor__tab__content'
  VUE_MARKDOWN_PREVIEW_OUTER_DOM = '#script__tale__preview__tab__content'
  MOBILE_HIDDEN_CLASS = 'hidden-xs'

  # form suggest
  FORM_INPUT_ID = 'script__tale__form__input'
  FORM_SUGGEST_ID = 'script__tale__form__suggest'
  FORM_SUGGEST_OPTIONS_ID = 'script__tale__form__suggest__options'
  FORM_INPUT_DOM = '#' + FORM_INPUT_ID

  # keycode
  ENTER_KEY_CODE = 13
  SPACE_KEY_CODE = 32
  COMMA_KEY_CODE = 44

  # ---------------------------------------------------------------------
  # logic for markdown
  # ---------------------------------------------------------------------
  # check DOM
  if document.getElementById(VUE_MARKDOWN_ID) != null

    # tab for mobile
    My100TalesUtilTab.createTab(
      SWITCH_MARKDOWN_EDITOR_DOM,
      SWITCH_MARKDOWN_PREVIEW_DOM,
      VUE_MARKDOWN_EDITOR_OUTER_DOM,
      VUE_MARKDOWN_PREVIEW_OUTER_DOM,
      MOBILE_HIDDEN_CLASS
    )

    # markdown preview
    my100tales_util_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    My100TalesUtilMarkdownPreview.previewMarkdown(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)

  # ---------------------------------------------------------------------
  # logic for tag
  # ---------------------------------------------------------------------
  # check DOM
  if document.getElementById(FORM_SUGGEST_ID) != null && document.getElementById(FORM_SUGGEST_OPTIONS_ID) != null

    # form suggest options
    suggestList = []
    index = -1
    while true

      # loop
      index++
      FORM_SUGGEST_OPTION_ID = FORM_SUGGEST_OPTIONS_ID + '__' + index
      break if document.getElementById(FORM_SUGGEST_OPTION_ID) == null
      # value
      option = document.getElementById(FORM_SUGGEST_OPTION_ID).innerText
      suggestList.push(option)

#    # form suggest create
#    new Suggest.LocalMulti(
#      FORM_INPUT_ID, # input
#      FORM_SUGGEST_ID, # output
#      suggestList, # target list
#      {
#        interval: 1000,
#        dispMax: 5,
#        highlight: true,
#        classMouseOver: 'layout__tale__form__suggest__over',
#        classSelect: 'layout__tale__form__suggest__select',
#        delim: ','
#      } # refs. http://www.enjoyxstudy.com/javascript/suggest/
#    )

    bloodhound = new Bloodhound({
      datumTokenizer: (d) ->
        datum = Bloodhound.tokenizers.whitespace(d.value)
        $.each(datum, (k,v) ->
          i = 0
          while(i+1 < v.length)
            datum.push(v.substr(i, v.length))
            i++
        )
        return datum
      ,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      local: $.map(suggestList, (value) -> return { value: value, countlist: 20 })
    })
    bloodhound.initialize()

    $('#script__bloodhound input').tagsinput({
      typeaheadjs: [{
        hint: true,
        highlight: true,
        minLength: 1
      },{
        valueKey: 'value',
        displayKey: 'value',
        itemValue: 'value',
        itemText: 'value',
        source: bloodhound.ttAdapter(), # data set
        templates: {
          suggestion: (data) -> return '<div>' + data.value + ':' + data.countlist + '</div>'
        }
      }],
      confirmKeys: [ENTER_KEY_CODE, SPACE_KEY_CODE, COMMA_KEY_CODE]
    }) # FORM_INPUT_ID
