class SessionsController < ApplicationController
  skip_before_filter :require_yammer_login,
    only: [:create, :destroy, :oauth_failure]

  def create
    user = post_authentication_steps
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
    flash[:error] = 'You denied access to Yammer'
    redirect_to request.env['omniauth.origin'] || root_url
  end

  private

  def post_authentication_steps
    user = find_or_instantiate_user
    refresh_user_data_from_yammer(user)
    user.update_watermark
    user
  end

  def find_or_instantiate_user
    user = User.find_by_yammer_user_id(omniauth[:uid])

    if user.nil?
      user = User.new(
        yammer_staging: omniauth_staging?,
        yammer_user_id: omniauth[:uid]
      )
    end

    user.access_token = omniauth_token
    user
  end

  def refresh_user_data_from_yammer(user)
    yammer_user_data = user.yammer_client.get("/users/#{omniauth[:uid]}")
    YammerUserResponseTranslator.
      new(yammer_user_data, user).
      translate.
      save!
  end

  def after_sign_in_path
    if session[:return_to].blank?
      new_event_path
    else
      session.delete(:return_to)
    end
  end

  def log_out_guest
    session[:name] = nil
    session[:email] = nil
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
end
