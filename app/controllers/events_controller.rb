class EventsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = EventDecorator.new(current_user.events.build)
    @event.build_suggestions
  end

  def create
    @event = EventDecorator.new(current_user.events.new(params[:event]))

    if @event.save
      redirect_to multiple_invitations_path(event_uuid: @event.uuid)
    else
      @event.build_suggestions
      render :new
    end
  end

  def show
    @event = EventDecorator.find_by_uuid!(params[:id])
    verify_or_setup_invitation_for_current_user
    setup_invitations
    render "events/show/#{current_user_class_name}"
  end

  def edit
    session[:return_to] = request.referer
    @event = EventDecorator.new(current_user.events.find_by_uuid!(params[:id]))
    @event.build_suggestions
  end

  def update
    @event = EventDecorator.new(current_user.events.find_by_uuid!(params[:id]))
    @event.attributes = params[:event]

    if @event.save
      respond_to do |format|
        format.html { redirect_to(session[:return_to] || @event) }
        format.json { render json: { status: :ok } }
      end
    else
      @event.build_suggestions
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

  def setup_invitations
    @invitation = Invitation.new
    @invitation.event = @event
    @invitation.invitee = current_user_class.new
  end

  def verify_or_setup_invitation_for_current_user
    if @event.user_not_invited?(current_user)
      invitation = Invitation.new(event: @event, invitee: current_user)
      invitation.invite_without_notification
      @event.reload
    end
  end
end
