class Messenger
  def initialize(invitation, sender=invitation.sender)
    @invitation = invitation
    @sender = sender
  end

  def invite
    UserMailer.invitation(@invitation).deliver
  end

  def remind
    UserMailer.reminder(@invitation, @sender).deliver
  end
end
