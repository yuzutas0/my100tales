# util/modal
class @My100TalesUtilModal

  @createModal = (dom) ->
    new Vue(
      el: dom
      data:
        display: false
      methods:
        showModal: ->
          this.display = true
        closeModal: ->
          this.display = false
    )
