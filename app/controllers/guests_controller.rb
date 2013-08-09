class GuestsController < ApplicationController
  layout 'events'

  skip_before_filter :require_yammer_login
  before_filter :authorize
  before_filter :force_yammer_users_to_login_with_yammer, only: :create

  def new
    @guest = Guest.find_or_initialize_by(email: session.delete(:guest_email))
    @event = find_event
    @show_guest_login = show_guest_login?
    session[:return_to] = event_url(@event)
  end

  def create
    @guest = find_or_initialize_guest
    @event = find_event
    @show_guest_login = show_guest_login?

    if @guest.save
      log_in_guest
      redirect_to previous_page
    else
      render :new
    end
  end

  def update
    @guest = Guest.find_by_email!(params[:guest][:email])
    @event = find_event

    if @guest.update_attributes(guest_params)
      log_in_guest
      redirect_to event_url(@event)
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

  def force_yammer_users_to_login_with_yammer
    if User.find_by_email(params[:guest][:email])
      session[:existing_yammer_user] = true
      redirect_to new_guest_path(event_id: params[:event_id]),
        notice: "Please sign in with your Yammer account"
    end
  end

  def find_event
    Event.find_by_uuid!(params[:event_id])
  end

  def guest_params
    params.require(:guest).permit(
      :email,
      :has_ever_logged_in,
      :name
    )
  end

  def show_guest_login?
    not (session.delete(:referred_from_yammer) ||
      session.delete(:existing_yammer_user))
  end

  def find_or_initialize_guest
    guest = Guest.find_or_initialize_by(email: params[:guest][:email])
    guest.update_attributes(
      name: params[:guest][:name],
      has_ever_logged_in: true
    )
    guest
  end

  def log_in_guest
    session[:event_id] = params[:event_id]
    session[:name] = @guest.name
    session[:email] = @guest.email
  end
end
