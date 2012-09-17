require 'spec_helper'

describe InvitationCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs find: invitation

    InvitationCreatedJob.enqueue invitation

    should enqueue_delayed_job('InvitationCreatedJob').
      with_attributes(invitation_id: invitation.id).
      priority(1)
  end
end

describe InvitationCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs(find: invitation)
    invitation.stubs(:send_invitation)
    action = InvitationCreatedJob::ACTION
    event = invitation.event

    InvitationCreatedJob.new(invitation.id).perform

    invitation.should have_received(:send_invitation).once
  end
end
