class InvitationsController < ApplicationController
  layout 'events'

  def create
    @event = Event.find(session[:current_event])
    @invitation = Invitation.invite_from_params(@event, params[:invitation])
    @suggestions = @event.suggestions

    if @invitation.errors.any?
      flash[:error] = @invitation.errors.full_messages.to_sentence
    end

    render "events/show"
  end
end
