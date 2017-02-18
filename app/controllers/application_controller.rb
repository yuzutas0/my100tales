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
  # CSRF
  # -----------------------------------------------------------------
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # -----------------------------------------------------------------
  # devise
  # -----------------------------------------------------------------
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_current_location, unless: :devise_controller?
  before_action :authenticate_user!

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  protected

  # -----------------------------------------------------------------
  # for locale lang
  # -----------------------------------------------------------------
  # set information
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  # set request parameter
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # -----------------------------------------------------------------
  # for devise
  # -----------------------------------------------------------------
  # params for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :timezone])
  end

  # friendly forward
  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_in_path_for(_resource)
    return tales_path if view_context.root_path_list.include?(session[:user_return_to])
    session[:user_return_to]
  end
end
