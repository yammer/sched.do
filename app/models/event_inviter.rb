class EventInviter
  def initialize(options = {})
    @current_user = options[:current_user]
    @event = options[:event]
    @invitation_text = options[:invitation_text]
    @invitee_emails = options[:invitee_emails]
  end

  def valid?
    invitations.map(&:valid?).exclude? false
  end

  def send_invitations
    invitations.map do |invitation|
      invitation.invite
    end
  end

  def invalid_invitation_errors
    invalid_invitations = invitations.select(&:invalid?)
    invalid_invitations.first.errors.full_messages.join(', ')
  end

  private

  def invitations
    @invitations ||= @invitee_emails.map do |email|
      build_invitation_for(email)
    end
  end

  def build_invitation_for(email)
    Invitation.new(
      event: @event,
      invitation_text: @invitation_text,
      invitee: find_or_create_user(email),
      sender: @current_user
    )
  end

  def find_or_create_user(email)
    InviteeBuilder.new(email.strip, @event).find_user_by_email_or_create_guest
  end
end
