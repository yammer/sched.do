class EventsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = current_user.events.build
    @event.build_suggestions
  end

  def create
    @event = current_user.events.new(params[:event])

    if @event.save
      redirect_to @event
    else
      @event.build_suggestions
      render :new
    end
  end

  def show
    @event = EventDecorator.find_by_uuid!(params[:id])
    verify_or_setup_invitation_for_current_user
    setup_invitation_for_event_creator
    render "events/show/#{@event.role(current_user)}"
  end

  def edit
    @event = current_user.events.find_by_uuid!(params[:id])
    @event.build_suggestions
  end

  def update
    @event = current_user.events.find_by_uuid!(params[:id])
    @event.attributes = params[:event]

    if @event.save
      redirect_to @event
    else
      @event.build_suggestions

      if @event.errors[:suggestions]
        flash[:error] = @event.errors.messages[:suggestions].to_sentence
      end

      render :edit
    end
  end

  private

  def setup_invitation_for_event_creator
    if current_user.able_to_edit?(@event)
      @invitation = Invitation.new
      @invitation.invitee = User.new
      @invitation.event = @event
    end
  end

  def verify_or_setup_invitation_for_current_user
    if !@event.user_invited?(current_user)
      Invitation.invite_without_notification(@event, current_user)
      @event.reload
    end
  end
end
