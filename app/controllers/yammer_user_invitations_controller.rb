class YammerUserInvitationsController < ApplicationController
  def create
    @event = Event.find(event_id)
    invitee = YammerUser.new(auth).find_or_create
    invitation = Invitation.new(
      event: @event,
      invitee: invitee,
      sender: current_user
    )
    invitation.invite

    if invitation.invalid?
      flash[:error] = invitation.errors.full_messages.last
    end

    redirect_to invitation.event
  end

  private

  def auth
    {
      access_token: current_user.access_token,
      yammer_staging: current_user.yammer_staging?,
      yammer_user_id: invitee_id
    }
  end

  def event_id
    params[:invitation][:event_id]
  end

  def invitee_id
    params[:invitation][:invitee_attributes][:yammer_user_id]
  end
end
