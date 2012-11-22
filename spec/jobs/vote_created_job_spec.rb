require 'spec_helper'

describe VoteCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    vote = build_stubbed(:vote)
    Vote.stubs(find: vote)

    VoteCreatedJob.enqueue(vote)

    should enqueue_delayed_job('VoteCreatedJob').
      with_attributes(vote_id: vote.id).
      priority(1)
  end
end

describe VoteCreatedJob, '#perform' do
  it 'enqueues an ActivityCreatorJob for Yammer users' do
    vote = build_stubbed(:vote)
    Vote.stubs(find: vote)
    user = vote.voter
    action = 'vote'
    event = vote.event
    ActivityCreatorJob.stubs(:enqueue)

    VoteCreatedJob.new(vote.id).perform

    ActivityCreatorJob.should have_received(:enqueue).with(user, action, event)
  end

  it 'does not enqueue an ActivityCreatorJob for guests' do
    vote = build_stubbed(:guest_vote)
    Vote.stubs(find: vote)
    user = vote.voter
    action = 'vote'
    event = vote.event
    ActivityCreatorJob.stubs(:enqueue)

    VoteCreatedJob.new(vote.id).perform

    ActivityCreatorJob.should have_received(:enqueue).
      with(user, action, event).never
  end

  it 'enqueues a VoteConfirmationEmailJob' do
    vote = build_stubbed(:vote)
    Vote.stubs(find: vote)
    VoteConfirmationEmailJob.stubs(:enqueue)

    VoteCreatedJob.new(vote.id).perform

    VoteConfirmationEmailJob.should have_received(:enqueue).with(vote)
  end

  it 'configures Yammer' do
    voter = build_stubbed(:user)
    vote = build_stubbed(:vote, voter: voter)
    Vote.stubs(find: vote)

    VoteCreatedJob.new.perform

    Yam.oauth_token.should == voter.access_token
  end
end

describe VoteCreatedJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    vote = build_stubbed(:vote)
    Airbrake.stubs(:notify)
    exception = 'Hey! You did something wrong!'

    job = VoteCreatedJob.new(vote.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end
