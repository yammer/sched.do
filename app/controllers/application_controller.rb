class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_yammer_login

  hide_action :current_user=
  helper_method :current_user

  def current_user=(user)
    @current_user = user
  end

  private

  def signed_in?
    current_user.present? && !current_user.guest?
  end

  def current_user
    @current_user ||= User.find_by_encrypted_access_token(cookies[:encrypted_access_token])
    if session[:name] && session[:email]
      @current_user ||= Guest.new(name: session[:name], email: session[:email])
    end
    @current_user
  end

  def require_yammer_login
    if current_user.blank? || current_user.guest?
      redirect_to root_path
    end
  end

  def require_guest_or_yammer_login
    if current_user.blank?
      session[:return_to] ||= request.fullpath
      redirect_to new_guest_url
    end
  end
end
