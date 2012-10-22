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

describe InvitationCreatedJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    invitation = build_stubbed(:invitation)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = InvitationCreatedJob.new(invitation.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe InvitationCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs(find: invitation)
    invitation.stubs(:deliver_invitation)
    event = invitation.event

    InvitationCreatedJob.new(invitation.id).perform

    invitation.should have_received(:deliver_invitation).once
  end
end
