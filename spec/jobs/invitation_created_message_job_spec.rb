require 'spec_helper'

describe InvitationCreatedMessageJob, '.enqueue' do
  it 'enqueues the job' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs find: invitation

    InvitationCreatedMessageJob.enqueue invitation

    should enqueue_delayed_job('InvitationCreatedMessageJob').
      with_attributes(invitation_id: invitation.id).
      priority(1)
  end
end

describe InvitationCreatedMessageJob, '#perform' do
  it 'sends the invitation message to the invitee' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs(find: invitation)
    invitee = invitation.invitee
    invitee.stubs(:invite)

    InvitationCreatedMessageJob.new(invitation.id).perform

    invitee.should have_received(:invite).with(invitation)
  end
end

describe InvitationCreatedMessageJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    invitation = build_stubbed(:invitation)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = InvitationCreatedMessageJob.new(invitation.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end
