class InvitationCreatedMessageJob < Struct.new(:invitation_id)
  PRIORITY = 1

  def self.enqueue(invitation)
    Delayed::Job.enqueue(new(invitation.id), priority: PRIORITY)
  end

  def perform
    invitee.invite(invitation)
  end

  def error(job, exception)
    unless ExceptionSilencer.is_rate_limit?(exception)
      Airbrake.notify(exception)
    end
  end

  def failure(job)
    Airbrake.notify(error_message: "Job failure: #{job.last_error}")
  end

  private

  def invitation
    @invitation ||= Invitation.find(invitation_id)
  end

  def invitee
    @invitee ||= invitation.invitee
  end
end
