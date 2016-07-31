# util/modal
class @My100TalesUtilModal

  @create_modal = (dom) ->
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
