class InvitationsController < ApplicationController
  layout 'events'

  def create
    @invitation = Invitation.new(params[:invitation])
    @event =  @invitation.event

    if !@invitation.save
      flash[:error] = @invitation.errors.full_messages.last
    end

    redirect_to @event
  end
end
