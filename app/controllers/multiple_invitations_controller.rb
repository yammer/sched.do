class MultipleInvitationsController < ApplicationController
  def index
    @event = Event.find_by_uuid(params[:event_uuid])
  end
end
