class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticated
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u| 
      u.permit(
        :first_name,
        :last_name,
        :email,
        :phone,
        :password,
        :password_confirmation
      )
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :first_name,
        :middle_name,
        :last_name,
        :email,
        :phone_number,
        :phone_ext,
        :job,
        :password,
        :password_confirmation,
        :current_password
      )
    end
  end

  protected

  def authenticated
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def admin_only
    unless user_signed_in? and current_user.permission_level == "Admin"
      redirect_to root_path
    end
  end
end