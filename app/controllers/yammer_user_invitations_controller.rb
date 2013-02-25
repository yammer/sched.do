class YammerUserInvitationsController < ApplicationController

  def create
    @event = Event.find(event_id)
    invitee = find_or_create_user
    invitation = Invitation.new(
      event: @event,
      invitee: invitee,
      sender: current_user
    )
    invitation.invite

    if invitation.invalid?
      flash[:error] = invitation.errors.full_messages.join(', ')
    end

    redirect_to invitation.event
  end

  private

  def find_or_create_user
    User.find_by_yammer_user_id(invitee_id) || create_user_from(invitee_id)
  end

  def create_user_from(invitee_id)
    invitee_data = @event.owner.yammer_client.get("/users/#{invitee_id}")
    User.new.tap do |user|
      YammerUserResponseTranslator.
        new(invitee_data, user).
        translate.
        save!
    end
  end

  def event_id
    params[:invitation][:event_id]
  end

  def invitee_id
    params[:invitation][:invitee_attributes][:yammer_user_id]
  end
end
