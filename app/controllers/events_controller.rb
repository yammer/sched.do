class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = 'Sorry, you are not authorized to view that event.'
    redirect_to root_path
  end

  def new
    @event = current_user.events.build
    populate_suggestions_for(@event)
    @suggestions = @event.suggestions
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
      populate_suggestions_for(@event)
      @suggestions = event.suggestions
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @suggestions = @event.suggestions
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    event = current_user.events.find(params[:id])
    if event.update_attributes(params[:event])
      flash[:success] = 'Event successfully updated.'
      redirect_to event
    else
      @event = event
      flash[:failure] = 'Please check the errors and try again.'
      render :edit
    end
  end

  private

  def populate_suggestions_for(event)
    5.times { event.suggestions.build }
  end
end
