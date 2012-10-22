require 'spec_helper'

describe VoteCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    vote = build_stubbed(:vote)
    Vote.stubs find: vote

    VoteCreatedJob.enqueue vote

    should enqueue_delayed_job('VoteCreatedJob').
      with_attributes(vote_id: vote.id).
      priority(1)
  end
end

describe VoteCreatedJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    vote = build_stubbed(:vote)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = VoteCreatedJob.new(vote.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe VoteCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    vote = build_stubbed(:vote)
    Vote.stubs(find: vote)
    voter = vote.voter
    voter.stubs(:create_yammer_activity)
    action = VoteCreatedJob::ACTION
    event = vote.event

    VoteCreatedJob.new(vote.id).perform

    voter.should have_received(:create_yammer_activity).
      with(action, event)
  end

  it 'enqueues a VoteConfirmationEmailJob' do
    vote = build_stubbed(:vote)
    Vote.stubs find: vote
    VoteConfirmationEmailJob.stubs(:enqueue)

    VoteCreatedJob.new(vote.id).perform

    VoteConfirmationEmailJob.should have_received(:enqueue).with(vote)
  end
end
