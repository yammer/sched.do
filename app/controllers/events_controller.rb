class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = 'Sorry, you are not authorized to view that event.'
    redirect_to root_path
  end

  skip_before_filter :require_yammer_login, only: :show
  before_filter :require_guest_or_yammer_login, only: :show

  def new
    @event = current_user.events.build
    @suggestions = populate_suggestions_for(@event)
  end

  def create
    @event = current_user.events.new(params[:event])
    @event.suggestions = @event.suggestions.select(&:valid?)

    if @event.save
      redirect_to @event
    else
      flash[:error] = "Please complete all required fields."
      @suggestions = populate_suggestions_for(@event)
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @suggestions = @event.suggestions
    verify_or_setup_invitation_for_current_user
    setup_invitation_for_event_creator
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    event = current_user.events.find(params[:id])
    event.attributes = params[:event]

    if event.save
      redirect_to event
    else
      @event = event
      flash[:failure] = 'Please check the errors and try again.'
      render :edit
    end
  end

  private

  def populate_suggestions_for(event)
    if event.suggestions.empty?
      2.times { event.suggestions.build }
    end
    event.suggestions
  end

  def populate_invitations_for(event)
    event.invitations.build
  end

  def verify_or_setup_invitation_for_current_user
    if !@event.user_invited?(current_user)
      Inviter.new(@event).invite(current_user)
      @event.reload
    end
  end

  def setup_invitation_for_event_creator
    if current_user.able_to_edit?(@event)
      @invitation = Invitation.new
      session[:current_event] = @event.id
    end
  end
end
