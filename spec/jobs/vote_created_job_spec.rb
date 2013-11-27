require 'spec_helper'

describe VoteCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    vote = build_stubbed(:vote)
    Vote.stub(find: vote)
    Delayed::Job.stub(:enqueue)
    vote_created_job = VoteCreatedJob.new(vote.id)

    VoteCreatedJob.enqueue(vote)

    expect(Delayed::Job).to have_received(:enqueue).with(vote_created_job)
  end
end

describe VoteCreatedJob, '#perform' do
  context 'when the vote exists' do
    it 'enqueues an ActivityCreatorJob for Yammer users' do
      vote = build_stubbed(:vote)
      Vote.stub(find_by_id: vote)
      user = vote.voter
      action = 'vote'
      event = vote.event
      ActivityCreatorJob.stub(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      expect(ActivityCreatorJob).to have_received(:enqueue).
        with(user, action, event)
    end

    it 'does not enqueue an ActivityCreatorJob for guests' do
      vote = build_stubbed(:guest_vote)
      Vote.stub(find: vote)
      user = vote.voter
      action = 'vote'
      event = vote.event
      ActivityCreatorJob.stub(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      expect(ActivityCreatorJob).not_to have_received(:enqueue).
        with(user, action, event)
    end

    it 'enqueues a VoteEmailJob that sends the vote confirmation email' do
      vote = create(:vote)
      Vote.stub(find_by_id: vote)
      VoteEmailJob.stub(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      expect(VoteEmailJob).to have_received(:enqueue).with(vote, :vote_confirmation)
    end

    it 'enqueues a VoteEmailJob that sends the vote notification email' do
      vote = create(:vote)
      Vote.stub(find_by_id: vote)
      VoteEmailJob.stub(:enqueue)

      VoteCreatedJob.new(vote.id).perform

      expect(VoteEmailJob).to have_received(:enqueue).with(vote, :vote_notification)
    end

    it 'configures Yammer' do
      voter = build_stubbed(:user)
      vote = build_stubbed(:vote, voter: voter)
      Vote.stub(find: vote)

      VoteCreatedJob.new.perform

      expect(voter.yammer_client.oauth_token).to eq voter.access_token
    end
  end

  context 'when the vote does not exist' do
    it 'does not enqueue an ActivityCreatorJob for Yammer users' do
      vote_id = nil
      ActivityCreatorJob.stub(:enqueue)

      VoteCreatedJob.new(vote_id).perform

      expect(ActivityCreatorJob).not_to have_received(:enqueue)
    end

    it 'does not enqueue a vote email job' do
      vote_id = nil
      VoteEmailJob.stub(:enqueue)

      VoteCreatedJob.new(vote_id).perform

      expect(VoteEmailJob).not_to have_received(:enqueue)
    end
  end
end

describe VoteCreatedJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    vote = build_stubbed(:vote)
    Airbrake.stub(:notify)
    exception = 'Hey! You did something wrong!'

    job = VoteCreatedJob.new(vote.id)
    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end
end
