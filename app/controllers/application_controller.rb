class ApplicationController < ActionController::Base
  protect_from_forgery

  hide_action :current_user=

  def current_user=(user)
    @current_user = user
  end

  private

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by_encrypted_access_token(cookies[:encrypted_access_token])
  end
end
