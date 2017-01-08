# devise/form
@my100tales_devise_form = ->

  # const
  VUE_SIGNUP_ID = 'script__devise__signup'
  VUE_SIGNUP_AGREEMENT_DOM = '#script__devise__signup__agreement'
  VUE_SIGNUP_SUBMIT_DOM = '#script__devise__signup__submit'

  # check DOM
  if document.getElementById(VUE_SIGNUP_ID) != null

    # disabled
    # agreement / submit
    My100TalesUtilDisable.setDisabled(VUE_SIGNUP_AGREEMENT_DOM, VUE_SIGNUP_SUBMIT_DOM)