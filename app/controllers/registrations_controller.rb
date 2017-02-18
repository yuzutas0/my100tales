#
# RegistrationsController (Override)
#
class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :set_locale
  prepend_before_filter :set_locale

  protected
    def after_update_path_for(_resource)
      edit_user_registration_path
    end
end
