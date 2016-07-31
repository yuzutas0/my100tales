# util/modal
class @My100TalesUtilModal

  @createModal = (dom, actions...) ->
    new Vue(
      el: dom
      data:
        display: false
      methods:
        showModal: ->
          this.display = true
          for action in actions then action
        closeModal: ->
          this.display = false
    )
