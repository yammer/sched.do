require 'spec_helper'

describe VoteCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    vote = build_stubbed(:vote)
    Vote.stubs(find: vote)
    Delayed::Job.stubs(:enqueue)
    vote_created_job = VoteCreatedJob.new(vote.id)
    priority = 1

    VoteCreatedJob.enqueue(vote)

    Delayed::Job.should have_received(:enqueue).
      with(vote_created_job, priority: priority)
  end
end

describe VoteCreatedJob, '#perform' do
  context 'when the vote exists' do
    it 'enqueues an ActivityCreatorJob for Yammer users' do
      vote = build_stubbed(:vote)
      Vote.stubs(find_by_id: vote)
      user = vote.voter
      action = 'vote'
      event = vote.event
      ActivityCreatorJob.stubs(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      ActivityCreatorJob.should have_received(:enqueue).
        with(user, action, event)
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

    it 'enqueues a VoteEmailJob that sends the vote confirmation email' do
      vote = create(:vote)
      Vote.stubs(find_by_id: vote)
      VoteEmailJob.stubs(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      VoteEmailJob.should have_received(:enqueue).with(vote, :vote_confirmation)
    end

    it 'enqueues a VoteEmailJob that sends the vote notification email' do
      vote = create(:vote)
      Vote.stubs(find_by_id: vote)
      VoteEmailJob.stubs(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      VoteEmailJob.should have_received(:enqueue).with(vote, :vote_notification)
    end

    it 'configures Yammer' do
      voter = build_stubbed(:user)
      vote = build_stubbed(:vote, voter: voter)
      Vote.stubs(find: vote)

      VoteCreatedJob.new.perform

      voter.yammer_client.oauth_token.should == voter.access_token
    end
  end

  context 'when the vote does not exist' do
    it 'does not enqueue an ActivityCreatorJob for Yammer users' do
      vote_id = nil
      ActivityCreatorJob.stubs(:enqueue)

      VoteCreatedJob.new(vote_id).perform

      ActivityCreatorJob.should have_received(:enqueue).never
    end

    it 'does not enqueue a vote email job' do
      vote_id = nil
      VoteEmailJob.stubs(:enqueue)

      VoteCreatedJob.new(vote_id).perform

      VoteEmailJob.should have_received(:enqueue).never
    end
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
