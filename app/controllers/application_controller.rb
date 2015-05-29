class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def index
  end

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  # Permitir loguearse con DNI o email
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation,
        :remember_me, :nombre)
    end

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :current_password,:nombre)
    end
  end

  private

    def forbid
      render status: :forbidden, text: '403 - Prohibido'
    end

    # Recuerda a donde teniamos que volver
    def return_to_this
      session[:return_to] = request.fullpath
    end

    # Vuelve y olvida de donde veniamos
    def return_to
      s = session[:return_to]
      session[:return_to] = nil

      s
    end
end
