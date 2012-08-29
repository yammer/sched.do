class EventsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = current_user.events.build
    @event.build_suggestions
  end

  def create
    @event = current_user.events.new(params[:event])
    @event.build_suggestions

    if @event.save
      redirect_to @event
    else
      flash[:error] = "Please complete all required fields."
      @event.build_suggestions
      render :new
    end
  end

  def show
    begin
      @event = Event.find_by_uuid!(params[:id])
      @event.build_suggestions
      verify_or_setup_invitation_for_current_user
      setup_invitation_for_event_creator
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Sorry, you are not authorized to view that event."
      redirect_to root_path
    end
  end

  def edit
    begin
      @event = current_user.events.find_by_uuid!(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Sorry, you are not authorized to edit that event."
      redirect_to root_path
    end
  end

  def update
    begin
      event = current_user.events.find_by_uuid!(params[:id])
      event.attributes = params[:event]

      if event.save
        redirect_to event
      else
        @event = event
        flash[:failure] = "Please check the errors and try again."
        render :edit
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
      flash[:error] = "Sorry, you are not authorized to edit that event."
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
