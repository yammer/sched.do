class Messenger
  def initialize(recipient)
    @recipient = recipient
  end

  def invite(invitation)
    UserMailer.invitation(invitation).deliver
  end

  def remind(event, sender)
    UserMailer.reminder(@recipient, sender, event).deliver
  end

  def notify(event, message)
    UserMailer.winner_notification(@recipient, event, message).deliver
  end
end
