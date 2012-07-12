class InvitationsController < ApplicationController
  layout 'events'

  def create
    event = Event.find(session[:current_event])
    inviter = Inviter.new(event).invite_from_params(params[:invitation])
    redirect_to event
  end
end
