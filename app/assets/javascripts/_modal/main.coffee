# common
@my100tales_sequels_modal_common = ->

  # loop for sequel length
  index = -1
  while true
    index++

    # const
    VUE_EDIT_ID = "vue__sequel__index--" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID

    # check DOM
    if document.getElementById(VUE_EDIT_ID) == null
      break

    # edit modal
    new Vue(
      el: VUE_EDIT_DOM
      data:
        display: false
      methods:
        show: ->
          this.display = true
        close: ->
          this.display = false
    )
