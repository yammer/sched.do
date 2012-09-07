class GuestsController < ApplicationController
  layout 'events'

  skip_before_filter :require_yammer_login
  before_filter :authorize

  def new
    @guest = Guest.find_or_initialize_by_email(session.delete(:guest_email))
    @event = Event.find_by_uuid(params[:event_id])
    @referred_from_yammer = session[:referred_from_yammer]
    session[:return_to]  = event_url(@event)
  end

  def create
    @guest = Guest.find_or_initialize_by_email(params[:guest][:email])
    @guest.name = params[:guest][:name]
    @event = Event.find_by_uuid(params[:event_id])

    if @guest.save
      log_in_guest
      redirect_to previous_page
    else
      render :new
    end
  end

  private
  def authorize
    if signed_in?
      redirect_to event_path(params[:event_id])
    end
  end

  def log_in_guest
    session[:name] = params[:guest][:name]
    session[:email] = params[:guest][:email]
  end
end
