# tales/form
@my100tales_tales_search = ->

  # const
  VUE_SEARCH_ID = 'script__tale__search'
  VUE_SEARCH_DOM = '#' + VUE_SEARCH_ID
  VUE_SEARCH_CONDITION_SAVE_DOM = '#input_condition_save'
  VUE_SEARCH_CONDITION_NAME_DOM = '#script__tale__search__condition__name'

  LEFT_TAB_SWITCH_DOM = '#script__tale__search__input__tab__switch'
  RIGHT_TAB_SWITCH_DOM = '#script__tale__search__condition__tab__switch'
  LEFT_TAB_CONTENT_DOM = '#script__tale__search__input__tab__content'
  RIGHT_TAB_CONTENT_DOM = '#script__tale__search__condition__tab__content'
  HIDDEN_CLASS = 'hidden'

  # check DOM
  if document.getElementById(VUE_SEARCH_ID) != null

    # modal
    @My100TalesUtilModal.createModal(VUE_SEARCH_DOM)

    # tab
    @My100TalesUtilTab.createTab(
      LEFT_TAB_SWITCH_DOM,
      RIGHT_TAB_SWITCH_DOM,
      LEFT_TAB_CONTENT_DOM,
      RIGHT_TAB_CONTENT_DOM,
      HIDDEN_CLASS
    )

    # disabled
    $(VUE_SEARCH_CONDITION_NAME_DOM).prop('disabled', !($(VUE_SEARCH_CONDITION_SAVE_DOM).is(':checked')))
    $(VUE_SEARCH_CONDITION_SAVE_DOM).on 'click', ->
      $(VUE_SEARCH_CONDITION_NAME_DOM).prop('disabled', !($(VUE_SEARCH_CONDITION_SAVE_DOM).is(':checked')))
