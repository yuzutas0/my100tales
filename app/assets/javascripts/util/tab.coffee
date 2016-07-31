# util/tab
class @My100TalesUtilTab

  # const
  ACTIVE_CLASS = 'active'
  CLICK = 'click'

  # TODO: jQuery#xxxClass -> Vue.js
  
  # create
  @createTab = (leftSwitch, rightSwitch, leftContent, rightContent, hiddenClass) ->

    # display both
    displayBothEditorAndPreview =->
      $(leftContent).removeClass(hiddenClass)
      $(rightContent).removeClass(hiddenClass)
      $(leftSwitch).parent().removeClass(ACTIVE_CLASS)
      $(rightSwitch).parent().removeClass(ACTIVE_CLASS)
  
    # display editor
    $(leftSwitch).on CLICK, ->
      displayBothEditorAndPreview()
      $(rightContent).addClass(hiddenClass)
      $(leftSwitch).parent().addClass(ACTIVE_CLASS)
  
    # display preview
    $(rightSwitch).on CLICK, ->
      displayBothEditorAndPreview()
      $(leftContent).addClass(hiddenClass)
      $(rightSwitch).parent().addClass(ACTIVE_CLASS)
