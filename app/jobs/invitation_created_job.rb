class InvitationCreatedJob < Struct.new(:invitation_id)
  PRIORITY = 1

  def self.enqueue(invitation)
    Delayed::Job.enqueue new(invitation.id), priority: PRIORITY
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    invitation.deliver_invitation
  end

  private

  def invitation
    Invitation.find(invitation_id)
  end
end
