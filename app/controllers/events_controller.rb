class EventsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = current_user.events.build
    view_context.build_suggestions(@event)
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to multiple_invitations_path(event_uuid: @event.uuid)
    else
      view_context.build_suggestions(@event)
      render :new
    end
  end

  def show
    @event = Event.find_by_uuid!(params[:id])
    verify_or_setup_invitation_for_current_user
    setup_invitations
    render "events/show/#{current_user_class_name}"
  end

  def edit
    session[:return_to] = request.referer
    @event = current_user.events.find_by_uuid!(params[:id])
    view_context.build_suggestions(@event)
  end

  def update
    @event = current_user.events.find_by_uuid!(params[:id])
    @event.attributes = event_params

    if @event.save
      respond_to do |format|
        format.html { redirect_to(session[:return_to] || @event) }
        format.json { render json: { status: :ok } }
      end
    else
      view_context.build_suggestions(@event)
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

  def current_user_class
    current_user.class.name.constantize
  end

  def current_user_class_name
    current_user.class.name.downcase
  end

  def event_params
    params.require(:event).permit(
      :name,
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
    if view_context.user_not_invited?(@event, current_user)
      invitation = Invitation.new(event: @event, invitee: current_user)
      invitation.invite_without_notification
      @event.reload
    end
  end
end
