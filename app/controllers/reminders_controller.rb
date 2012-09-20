class RemindersController < ApplicationController
  def create
    event = Event.find_by_uuid!(params[:event_id])
    decorated_event = EventDecorator.new(event)
    decorated_event.invitations_excluding_current_user.map(&:send_reminder)
    redirect_to event
  end
end
