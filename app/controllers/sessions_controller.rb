class SessionsController < ApplicationController
  skip_before_filter :require_yammer_login, only: [:create, :destroy, :oauth_failure]
  before_filter :require_tos_acceptance, only: [:create]

  def create
    user = find_or_create_with_auth
    user.fetch_yammer_user_data
    cookies.signed[:yammer_user_id] = user.yammer_user_id
    log_out_guest

    redirect_to after_sign_in_path
  end

  def destroy
    @current_user = nil
    log_out_guest
    cookies.signed[:yammer_user_id] = nil
    redirect_to root_path
  end

  def oauth_failure
    flash[:error] = "You denied access to Yammer"
    redirect_to request.env["omniauth.origin"] || root_url
  end

  private

  def after_sign_in_path
    if session[:return_to].blank?
      new_event_path
    else
      session.delete(:return_to)
    end
  end

  def auth
    request.env['omniauth.auth']
  end

  def find_or_create_with_auth
    User.find_or_create_with_auth(
        access_token: auth[:credentials][:token],
        yammer_staging: auth[:provider] == "yammer_staging",
        yammer_user_id: auth[:uid]
    )
  end

  def log_out_guest
    session[:name] = nil
    session[:email] = nil
  end
end
