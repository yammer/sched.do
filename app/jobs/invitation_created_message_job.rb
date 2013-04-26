class InvitationCreatedMessageJob < Struct.new(:invitation_id)
  include YammerRateLimited

  def self.enqueue(invitation)
    job = new(invitation.id)

    Delayed::Job.enqueue(job)
  end

  def perform
    invitee.invite(invitation)
  end

  private

  def invitation
    @invitation ||= Invitation.find(invitation_id)
  end

  def invitee
    @invitee ||= invitation.invitee
  end
end
