class SessionsController < ApplicationController
  def create
    user = User.new(name: auth[:info][:name], access_token: 'abc')
    user.yammer_user_id = yammer_user_id
    user.save!
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
end
