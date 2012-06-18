class GuestsController < ApplicationController
  skip_before_filter :require_yammer_login

  def new
    @guest = Guest.new
  end

  def create
    session[:name] = params[:guest][:name]
    session[:email] = params[:guest][:email]
    redirect_to(session[:return_to] || root_url)
  end
end
