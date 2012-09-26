class GuestsController < ApplicationController
  layout 'events'

  skip_before_filter :require_yammer_login
  before_filter :authorize
  before_filter :check_for_existing_yammer_user, only: :create

  def new
    @guest = Guest.find_or_initialize_by_email(session.delete(:guest_email))
    @event = Event.find_by_uuid(params[:event_id])
    @show_guest_login = show_guest_login?
    session[:return_to]  = event_url(@event)
  end

  def create
    @guest = Guest.find_or_initialize_by_email(params[:guest][:email])
    @guest.name = params[:guest][:name]
    @event = Event.find_by_uuid(params[:event_id])
    @show_guest_login = show_guest_login?

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

  def check_for_existing_yammer_user
    if User.find_by_email(params[:guest][:email])
      session[:existing_yammer_user] = true
      redirect_to new_guest_path(event_id: params[:event_id]), notice: "Please sign in with your Yammer account"
    end
  end

  def log_in_guest
    session[:name] = params[:guest][:name]
    session[:email] = params[:guest][:email]
  end

  def show_guest_login?
    not (session.delete(:referred_from_yammer) ||
      session.delete(:existing_yammer_user))
  end
end
