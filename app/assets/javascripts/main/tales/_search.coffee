# tales/form
@my100tales_tales_search = ->

  # const
  VUE_SEARCH_ID = 'script__tale__search'

  VUE_SEARCH_CONDITION_SAVE_DOM = '#input_condition_save'
  VUE_SEARCH_CONDITION_NAME_DOM = '#script__tale__search__condition__name'

  VUE_SEARCH_CONDITION_SCORE_ID_PREFIX = 'input_condition_score_'
  VUE_SEARCH_CONDITION_COMPARE_DOM_PREFIX = '#script__tale__search__condition__compare__'
  VUE_SEARCH_CONDITION_VALUE_DOM_PREFIX = '#script__tale__search__condition__value__'

  VUE_SEARCH_CONDITION_SORT_ID_PREFIX = 'input_sort_'

  LEFT_TAB_SWITCH_DOM = '#script__tale__search__input__tab__switch'
  RIGHT_TAB_SWITCH_DOM = '#script__tale__search__condition__tab__switch'
  LEFT_TAB_CONTENT_DOM = '#script__tale__search__input__tab__content'
  RIGHT_TAB_CONTENT_DOM = '#script__tale__search__condition__tab__content'

  HIDDEN_CLASS = 'hidden'

  # check DOM
  if document.getElementById(VUE_SEARCH_ID) != null

    # modal
    My100TalesUtilModal.createModal('#' + VUE_SEARCH_ID)

    # tab
    My100TalesUtilTab.createTab(
      LEFT_TAB_SWITCH_DOM,
      RIGHT_TAB_SWITCH_DOM,
      LEFT_TAB_CONTENT_DOM,
      RIGHT_TAB_CONTENT_DOM,
      HIDDEN_CLASS
    )

    # disabled
    # save / name
    My100TalesUtilDisable.setDisabled(VUE_SEARCH_CONDITION_SAVE_DOM, VUE_SEARCH_CONDITION_NAME_DOM)
    # score (key, compare, value)
    index = -1
    hashForSort = {}
    loop
      index++
      break if document.getElementById(VUE_SEARCH_CONDITION_SCORE_ID_PREFIX + index) == null
      dom = '#' + VUE_SEARCH_CONDITION_SCORE_ID_PREFIX + index
      hashForSort[$(dom).val()] = dom
      My100TalesUtilDisable.setDisabled(
        dom,
        VUE_SEARCH_CONDITION_COMPARE_DOM_PREFIX + index,
        VUE_SEARCH_CONDITION_VALUE_DOM_PREFIX + index
      )
    # sort
    index = -1
    loop
      index++
      break if document.getElementById(VUE_SEARCH_CONDITION_SORT_ID_PREFIX + index) == null
      dom = '#' + VUE_SEARCH_CONDITION_SORT_ID_PREFIX + index
      key = $(dom).val().split(':')[0]
      My100TalesUtilDisable.setDisabled(hashForSort[key], dom)
