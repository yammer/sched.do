require 'spec_helper'

describe InvitationCreatedMessageJob, '.enqueue' do
  it 'enqueues the job' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs(find: invitation)
    Delayed::Job.stubs(:enqueue)
    invitation_created_message_job =
      InvitationCreatedMessageJob.new(invitation.id)
    priority = 1

    InvitationCreatedMessageJob.enqueue(invitation)

    expect(Delayed::Job).to have_received(:enqueue).
      with(invitation_created_message_job, priority: priority)
  end
end

describe InvitationCreatedMessageJob, '#perform' do
  it 'sends the invitation message to the invitee' do
    invitation = build_stubbed(:invitation)
    Invitation.stubs(find: invitation)
    invitee = invitation.invitee
    invitee.stubs(:invite)

    InvitationCreatedMessageJob.new(invitation.id).perform

    expect(invitee).to have_received(:invite).with(invitation)
  end
end

describe InvitationCreatedMessageJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = InvitationCreatedMessageJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end

  it 'does not send exception to Airbrake if the job errors due to rate limit' do
    job = ReminderCreatedJob.new
    exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).never
  end
end

describe InvitationCreatedMessageJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = InvitationCreatedMessageJob.new
    job_record = stub(last_error: 'boom')
    Airbrake.stubs(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).with('Job failure: boom')
  end
end
