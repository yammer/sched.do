require 'spec_helper'

describe InvitationCreatedMessageJob, '.enqueue' do
  it 'enqueues the job' do
    invitation = build_stubbed(:invitation)
    Invitation.stub(find: invitation)
    Delayed::Job.stub(:enqueue)
    job = InvitationCreatedMessageJob.new(invitation.id)

    InvitationCreatedMessageJob.enqueue(invitation)

    expect(Delayed::Job).to have_received(:enqueue).with(job)
  end
end

describe InvitationCreatedMessageJob, '#perform' do
  it 'sends the invitation message to the invitee' do
    invitation = build_stubbed(:invitation)
    Invitation.stub(find: invitation)
    invitee = invitation.invitee
    invitee.stub(:invite)

    InvitationCreatedMessageJob.new(invitation.id).perform

    expect(invitee).to have_received(:invite).with(invitation)
  end
end

describe InvitationCreatedMessageJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = InvitationCreatedMessageJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stub(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end
end

describe InvitationCreatedMessageJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = InvitationCreatedMessageJob.new
    job_record = double(last_error: 'boom')
    Airbrake.stub(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).
      with(error_message: 'Job failure: boom')
  end
end

describe InvitationCreatedMessageJob, '#max_attempts' do
  it 'uses the global config settings' do
    job = InvitationCreatedMessageJob.new

    expect(job.max_attempts).to eq 5
  end

  context 'when rate limit error is encountered' do
    it 'overrides global delayed_job settings' do
      exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
      job = InvitationCreatedMessageJob.new
      job.error(job, exception)

      expect(job.max_attempts).to eq 50
    end
  end
end

describe InvitationCreatedMessageJob, '#reschedule_at' do
  context 'when rate limit error is encountered' do
    it 'overrides global delayed_job settings' do
      ignored = nil
      exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
      job = InvitationCreatedMessageJob.new
      job.error(job, exception)

      result = job.reschedule_at(ignored, ignored)

      expect(result).to be_within(1).of(30.seconds.from_now)
    end
  end
end
