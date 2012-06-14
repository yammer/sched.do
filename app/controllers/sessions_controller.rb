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

  def yammer_user_id
    auth[:uid]
  end

  def find_or_create_user
    user = User.find_by_access_token(auth[:info][:access_token])
    unless user
      user = User.new(name: auth[:info][:name], access_token: auth[:info][:access_token])
      user.yammer_user_id = yammer_user_id
      user.save!
      user
    end
    user
  end
end
