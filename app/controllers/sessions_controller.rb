class SessionsController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    user = find_or_create_user
    cookies[:encrypted_access_token] = user.encrypted_access_token

    flash[:success] = "You have successfully signed in."
    redirect_to new_event_path
  end

  def destroy
    @current_user = nil
    cookies[:encrypted_access_token] = nil
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def find_or_create_user
    find_user || User.create_from_params(auth)
  end

  def find_user
    User.find_by_access_token(auth[:info][:access_token])
  end
end
