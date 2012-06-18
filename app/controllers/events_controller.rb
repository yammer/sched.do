class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = 'Sorry, you are not authorized to view that event.'
    redirect_to root_path
  end

  def new
    @event = current_user.events.build
    @suggestions = populate_suggestions_for(@event)
  end

  def create
    event = current_user.events.new(params[:event])
    event.suggestions = event.suggestions.select(&:valid?)

    if event.save
      flash[:success] = "Event successfully created."
      redirect_to event
    else
      flash[:error] = "Please complete all required fields."
      @event = event
      @suggestions = populate_suggestions_for(@event)
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @suggestions = @event.suggestions
  end

  def edit
    @event = current_user.events.find(params[:id])
    @invitations = populate_invitations_for(@event)
  end

  def update
    event = current_user.events.find(params[:id])
    event.attributes = params[:event]
    event.invitations = event.invitations.select(&:valid?)

    if event.save
      flash[:success] = 'Event successfully updated.'
      redirect_to event
    else
      @event = event
      @invitations = populate_invitations_for(@event)
      flash[:failure] = 'Please check the errors and try again.'
      render :edit
    end
  end

  private

  def populate_suggestions_for(event)
    2.times { event.suggestions.build }
    event.suggestions
  end

  def populate_invitations_for(event)
    event.invitations.build
  end
end
