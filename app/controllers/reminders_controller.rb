class RemindersController < ApplicationController
  def create
    event = Event.find_by_uuid!(params[:event_id])
    event.invitations.map(&:send_reminder)
    redirect_to event
  end
end
