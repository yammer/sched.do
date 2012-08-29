class GuestsController < ApplicationController
  layout 'events'

  skip_before_filter :require_yammer_login

  def new
    @guest = Guest.find_or_create_by_email(session.delete(:guest_email))
    @event = Event.find_by_uuid(params[:event_id])
    @referred_from_yammer = session[:referred_from_yammer]
  end

  def create
    @guest = Guest.find_or_initialize_by_email(params[:guest][:email])
    @guest.name = params[:guest][:name]
    @event = Event.find_by_uuid(params[:event_id])

    if @guest.save
      log_in_guest
      return_to_previous_page
    else
      render :new
    end
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
