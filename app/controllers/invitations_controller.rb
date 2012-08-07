class InvitationsController < ApplicationController
  layout 'events'

  def create
    event = Event.find(session[:current_event])
    inviter = Invitation.invite_from_params(event, params[:invitation])
    redirect_to event
  end
end
