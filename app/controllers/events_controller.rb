class EventsController < ApplicationController
  include EventHelper
  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = current_user.events.build
    build_suggestions(@event)
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to multiple_invitations_path(event_uuid: @event.uuid)
    else
      build_suggestions(@event)
      render :new
    end
  end

  def show
    @event = Event.find_by_uuid!(params[:id])
    verify_or_setup_invitation_for_current_user
    setup_invitations
    if @event.closed?
      render 'events/show/closed'
    else
      render "events/show/#{current_user_class_name}"
    end
  end

  def edit
    session[:return_to] = request.referer
    @event = current_user.events.opened.find_by_uuid!(params[:id])
    build_suggestions(@event)
  end

  def update
    @event = current_user.events.opened.find_by_uuid!(params[:id])
    @event.attributes = event_params
    @event.open = open_flag

    if @event.save
      respond_to do |format|
        format.html { redirect_to(session[:return_to] || @event) }
        format.json { render json: { status: :ok } }
      end
    else
      build_suggestions(@event)
      add_errors_to_flash
      render :edit
    end
  end

  private

  def add_errors_to_flash
    if @event.errors[:suggestions].any?
      flash[:error] = @event.errors.messages[:suggestions].to_sentence
    end
  end

  def open_flag
    !(event_params[:open] == "false")
  end

  def current_user_class
    current_user.class.name.constantize
  end

  def current_user_class_name
    current_user.class.name.downcase
  end

  def event_params
    params.require(:event).permit(
      :name,
      :open,
      :primary_suggestions_attributes,
      :uuid,
      :watermarked_image
    )
  end

  def setup_invitations
    @invitation = Invitation.new
    @invitation.event = @event
    @invitation.invitee = current_user_class.new
  end

  def verify_or_setup_invitation_for_current_user
    if user_not_invited?(@event, current_user)
      text = last_non_owner_invitation_text(@event)
      invitation = Invitation.new(event: @event, invitation_text: text, invitee: current_user)
      invitation.invite_without_notification
      @event.reload
    end
  end
end
