class YammerUserInvitationsController < ApplicationController

  def create
    invitation = Invitation.new(args)
    invitation.invite

    if invitation.invalid?
      flash[:error] = invitation.errors.full_messages.join(', ')
    end

    redirect_to invitation.event
  end

  private

  def args
    {
      event: event,
      invitation_text: invitation_text,
      invitee: find_or_create_user,
      sender: current_user
    }
  end

  def create_user_from(invitee_id)
    invitee_data = owner_yammer_client.get_user(invitee_id).body
    User.new.tap do |user|
      YammerUserResponseTranslator.
        new(invitee_data, user).
        translate.
        save!
    end
  end

  def event
    Event.find(params[:invitation][:event_id])
  end

  def find_or_create_user
    User.find_by_yammer_user_id(invitee_id) || create_user_from(invitee_id)
  end

  def owner_yammer_client
    event.owner.yammer_client
  end

  def invitation_text
    params[:invitation][:invitation_text]
  end

  def invitee_id
    params[:invitation][:invitee_attributes][:yammer_user_id]
  end
end
