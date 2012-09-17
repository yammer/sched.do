class InvitationCreatedJob < Struct.new(:invitation_id)
  PRIORITY = 1
  ACTION = 'create'

  def self.enqueue(invitation)
    Delayed::Job.enqueue new(invitation.id), priority: PRIORITY
  end

  def perform
    invitation.send_invitation
  end

  private

  def invitation
    Invitation.find(invitation_id)
  end
end
