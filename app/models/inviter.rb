class Inviter
  def initialize(event)
    @event = event
  end

  def invite(user)
    Invitation.find_or_create_by_event_and_invitee(@event, user)
  end

  def invite_from_params(options)
    if options[:yammer_user_id]
      invitee = find_user_or_yammer_invitee(options[:yammer_user_id], options[:name_or_email])
    else
      invitee = find_guest(options[:name_or_email])
    end
    invite(invitee)
  end

  private

  def find_user_or_yammer_invitee(yammer_user_id, name)
    find_user(yammer_user_id) || find_yammer_invitee(yammer_user_id, name)
  end

  def find_user(yammer_user_id)
    User.find_by_yammer_user_id(yammer_user_id)
  end

  def find_yammer_invitee(yammer_user_id, name)
    YammerInvitee.find_or_create_by_yammer_user_id(yammer_user_id: yammer_user_id, name: name)
  end

  def find_guest(email)
    Guest.find_or_create_by_email(email)
  end
end

