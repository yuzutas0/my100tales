# tales/form
@my100tales_tales_search = ->

  # const
  VUE_SEARCH_ID = 'script__tale__search'
  VUE_SEARCH_DOM = '#' + VUE_SEARCH_ID
  VUE_SEARCH_CONDITION_SAVE_DOM = '#input_condition_save'
  VUE_SEARCH_CONDITION_NAME_DOM = '#script__tale__search__condition__name'

  # check DOM
  if document.getElementById(VUE_SEARCH_ID) != null

    # modal
    @My100TalesUtilModal.createModal(VUE_SEARCH_DOM)

    # disabled
    $(VUE_SEARCH_CONDITION_SAVE_DOM).on 'click', ->
      $(VUE_SEARCH_CONDITION_NAME_DOM).prop('disabled', !($(VUE_SEARCH_CONDITION_SAVE_DOM).is(':checked')))
