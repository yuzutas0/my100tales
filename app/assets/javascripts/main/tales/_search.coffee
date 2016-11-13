# tales/form
@my100tales_tales_search = ->

  # const
  VUE_SEARCH_ID = 'script__tale__search'
  VUE_SEARCH_DOM = '#' + VUE_SEARCH_ID
  VUE_SEARCH_CONDITION_SCORE_ID_PREFIX = 'input_condition_score_'
  VUE_SEARCH_CONDITION_SCORE_DOM_PREFIX = '#' + VUE_SEARCH_CONDITION_SCORE_ID_PREFIX
  VUE_SEARCH_CONDITION_COMPARE_DOM_PREFIX = '#script__tale__search__condition__compare__'
  VUE_SEARCH_CONDITION_VALUE_DOM_PREFIX = '#script__tale__search__condition__value__'
  VUE_SEARCH_CONDITION_SAVE_DOM = '#input_condition_save'
  VUE_SEARCH_CONDITION_NAME_DOM = '#script__tale__search__condition__name'

  LEFT_TAB_SWITCH_DOM = '#script__tale__search__input__tab__switch'
  RIGHT_TAB_SWITCH_DOM = '#script__tale__search__condition__tab__switch'
  LEFT_TAB_CONTENT_DOM = '#script__tale__search__input__tab__content'
  RIGHT_TAB_CONTENT_DOM = '#script__tale__search__condition__tab__content'
  HIDDEN_CLASS = 'hidden'

  disabled = (triggerDom, changeDom) ->
    $(changeDom).prop('disabled', !($(triggerDom).is(':checked')))
    $(triggerDom).on 'click', ->
      $(changeDom).prop('disabled', !($(triggerDom).is(':checked')))

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

    # disabled - save / name
    disabled(VUE_SEARCH_CONDITION_SAVE_DOM, VUE_SEARCH_CONDITION_NAME_DOM)

    # disabled - score
    # loop for score index length - 1
    index = -1
    loop
      index++

      VUE_SCORE_ID = VUE_SEARCH_CONDITION_SCORE_ID_PREFIX + index
      VUE_SCORE_DOM = VUE_SEARCH_CONDITION_SCORE_DOM_PREFIX + index
      VUE_COMPARE_DOM = VUE_SEARCH_CONDITION_COMPARE_DOM_PREFIX + index
      VUE_VALUE_DOM = VUE_SEARCH_CONDITION_VALUE_DOM_PREFIX + index

      if document.getElementById(VUE_SCORE_ID) == null
        break

      disabled(VUE_SCORE_DOM, VUE_COMPARE_DOM)
      disabled(VUE_SCORE_DOM, VUE_VALUE_DOM)
