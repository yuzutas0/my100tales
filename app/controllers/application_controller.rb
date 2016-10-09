#
# ApplicationController
#
class ApplicationController < ActionController::Base
  # -----------------------------------------------------------------
  # include
  # -----------------------------------------------------------------
  include ErrorHandlers

  # -----------------------------------------------------------------
  # exception
  # -----------------------------------------------------------------
  unless Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  # -----------------------------------------------------------------
  # locale
  # -----------------------------------------------------------------
  before_filter :set_locale

  # -----------------------------------------------------------------
  # devise
  # -----------------------------------------------------------------
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise User Setting
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  protected

  # -----------------------------------------------------------------
  # for locale lang
  # -----------------------------------------------------------------
  # set information
  def default_url_options(options={})
    { locale: I18n.locale }
  end

  # set request parameter
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # -----------------------------------------------------------------
  # for devise
  # -----------------------------------------------------------------
  # params for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # friendly forward
  def after_sign_in_path_for(_resource)
    session[:user_return_to] || tales_path
  end
end
