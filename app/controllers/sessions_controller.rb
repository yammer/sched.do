class SessionsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :create

  def create
    user = find_or_create_user
    cookies[:encrypted_access_token] = user.encrypted_access_token
    log_out_guest

    redirect_to after_sign_in_path
  end

  def destroy
    @current_user = nil
    log_out_guest
    cookies[:encrypted_access_token] = nil
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def find_or_create_user
    find_user || YammerInvitee.convert_to_user_from_params(auth) || User.create_from_params!(auth)
  end

  def find_user
    User.find_by_access_token(auth[:info][:access_token])
  end

  def log_out_guest
    session[:name] = nil
    session[:email] = nil
  end

  def after_sign_in_path
    if session[:return_to].blank?
      new_event_path
    else
      session[:return_to]
    end
  end
end
