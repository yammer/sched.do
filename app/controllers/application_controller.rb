class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_yammer_login
  before_filter :check_blank_token
  before_filter :set_token_and_endpoint

  hide_action :current_user=

  helper_method :current_user
  helper_method :signed_in?

  def signed_in?
    current_user.yammer_user?
  end

  def current_user=(user)
    @current_user = user
  end

  def set_token_and_endpoint
    if signed_in?
      oauth_token = current_user.access_token
      staging = current_user.yammer_staging
    elsif session[:event_id].present?
      event = Event.find_by_uuid!(session[:event_id])
      oauth_token = event.owner.access_token
      staging = event.owner.yammer_staging
    else
      oauth_token = omniauth_token
      staging = omniauth_staging?
    end

    Yam.configure do |config|
      config.oauth_token = oauth_token

      if staging
        config.endpoint = YAMMER_STAGING_ENDPOINT
      else
        config.endpoint = YAMMER_ENDPOINT
      end
    end
  end

  def current_user
    @current_user ||= CurrentUser.find(
      cookies.try(:signed).try(:[], :yammer_user_id),
      session[:name],
      session[:email]
    )
  end

  def check_blank_token
    if current_user_has_expired_token?
      current_user.reset_token
      redirect_to sign_out_path
    end
  end

  def omniauth
    request.env['omniauth.auth']
  end

  def omniauth_token
    omniauth.try(:[],:credentials).try(:[],:token)
  end

  def omniauth_staging?
    (omniauth.try(:[],:provider) == 'yammer_staging')
  end

  def require_yammer_login
    unless current_user.yammer_user?
      session[:return_to] ||= request.fullpath
      redirect_to view_context.auth_yammer_path
    end
  end

  def require_guest_or_yammer_login
    set_referred_from_yammer

    if current_user.blank?
      session[:return_to] ||= request.fullpath
      session[:guest_email] = params[:guest_email]
      redirect_to new_guest_url(event_id: params[:id])
    end
  end

  def previous_page
    session.delete(:return_to) || root_url
  end

  private

  def current_user_has_expired_token?
    signed_in? && current_user.access_token == 'EXPIRED'
  end

  def referred_from_yammer?
    referring_site.include?('yammer.com')
  end

  def referring_site
    request.env["HTTP_REFERER"].to_s
  end

  def set_referred_from_yammer
    session[:referred_from_yammer] = referred_from_yammer?
  end

  def user_rejected_tos
    request.env["omniauth.params"].try(:[],"agree_to_tos") == "0"
  end
end
