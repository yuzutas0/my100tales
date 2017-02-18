#
# RegistrationsController (Override)
#
class SessionsController < Devise::SessionsController
  skip_before_filter :set_locale
  prepend_before_filter :set_locale
end
