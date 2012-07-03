class Inviter
  def initialize(event)
    @event = event
  end

  def invite_user(user)
    Invitation.find_or_create_by_event_and_invitee(@event, user)
  end

  def invite_yammer_user_by_id(yammer_user_id)
    user = User.find_by_yammer_user_id(yammer_user_id)
    if user
      invite_user(user)
    end
  end

  def invite_yammer_invitee(yammer_user_id, name)
    yammer_invitee = YammerInvitee.find_or_create_by_yammer_user_id(yammer_user_id: yammer_user_id, name: name)
    if yammer_invitee
      invite_user(yammer_invitee)
    end
  end

  def invite_unknown_yammer_user(yammer_user_id, name)
    invite_yammer_user_by_id(yammer_user_id) || invite_yammer_invitee(yammer_user_id, name)
  end

  def invite_guest_by_email(email)
    guest = Guest.find_or_create_by_email(email)
    invite_user(guest)
  end
end
