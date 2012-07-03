class Inviter
  def initialize(event)
    @event = event
  end

  def invite_generic_user(user)
    if user.yammer_user?
      invite_user(user.yammer_user_id)
    else
      invite_guest(user.email)
    end
  end

  def invite_user(yammer_user_id)
    user = User.find_by_yammer_user_id(yammer_user_id)
    if user
      Invitation.find_or_create_by_event_and_invitee(@event, user)
    end
  end

  def invite_yammer_invitee(yammer_user_id, name)
    yammer_invitee = YammerInvitee.find_or_create_by_yammer_user_id(yammer_user_id: yammer_user_id, name: name)
    if yammer_invitee
      Invitation.find_or_create_by_event_and_invitee(@event, yammer_invitee)
    end
  end

  def invite_guest(email)
    guest = Guest.find_or_create_by_email(email)
    Invitation.find_or_create_by_event_and_invitee(@event, guest)
  end
end
