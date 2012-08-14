class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_yammer_login

  hide_action :current_user=
  helper_method :current_user
  helper_method :signed_in?

  def current_user=(user)
    @current_user = user
  end

  private

  def signed_in?
    current_user.yammer_user?
  end

  def current_user
    @current_user ||= CurrentUser.find(
      cookies.try(:signed).try(:[], :yammer_user_id),
      session[:name],
      session[:email]
    )
  end

  def require_yammer_login
    unless current_user.yammer_user?
      session[:return_to] ||= request.fullpath
      redirect_to view_context.auth_yammer_path
    end
  end

  def require_guest_or_yammer_login
    if current_user.blank?
      session[:return_to] ||= request.fullpath
      session[:guest_email] = params[:guest_email]
      redirect_to new_guest_url(event_id: params[:id])
    end
  end

  def previous_page
    session.delete(:return_to) || root_url
  end
end
