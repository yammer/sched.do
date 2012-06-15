class GuestsController < ApplicationController
  skip_before_filter :require_yammer_login

  def new
  end

  def create
    session[:name] = params[:name]
    session[:email] = params[:email]
    redirect_to session[:return_to]
  end
end
