class GuestsController < ApplicationController
  layout 'events'

  skip_before_filter :require_yammer_login

  def new
    @guest = Guest.new
    @guest.email = session.delete(:guest_email)
  end

  def create
    log_in_guest
    return_to_previous_page
  end

  private

  def log_in_guest
    session[:name] = params[:guest][:name]
    session[:email] = params[:guest][:email]
  end

  def return_to_previous_page
    redirect_to previous_page
  end
end
