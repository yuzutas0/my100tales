# common
@my100tales_sequels_modal_common = ->

  # common
  create_modal = (dom) ->
    new Vue(
      el: dom
      data:
        display: false
      methods:
        show: ->
          this.display = true
        close: ->
          this.display = false
    )

  # -------------
  # sequel new
  # -------------

  # const
  VUE_NEW_ID = "vue__sequel__new"
  VUE_NEW_DOM = "#" + VUE_NEW_ID

  # check DOM
  if document.getElementById(VUE_NEW_ID) != null
    create_modal(VUE_NEW_DOM)

  # -------------
  # sequel edit
  # -------------

  # loop for sequel index length
  index = -1
  while true
    index++

    # const
    VUE_EDIT_ID = "vue__sequel__index--" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID

    # check DOM
    if document.getElementById(VUE_EDIT_ID) != null
      create_modal(VUE_EDIT_DOM)
    else
      break
