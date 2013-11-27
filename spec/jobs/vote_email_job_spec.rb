require 'spec_helper'

describe VoteEmailJob, '.enqueue' do
  it 'enqueues the job' do
    Timecop.freeze do
      vote = build_stubbed(:vote)
      Delayed::Job.stub(:enqueue)
      vote_email_job = VoteEmailJob.new(vote.id, :test_vote_email)
      delay = 3.minutes

      VoteEmailJob.enqueue(vote, :test_vote_email)

      expect(Delayed::Job).to have_received(:enqueue).
        with(vote_email_job, run_at: delay.from_now)
    end
  end
end

describe VoteEmailJob, '#error' do
  it 'sends Airbrake an exception if the job fails' do
    vote = build_stubbed(:vote)
    Airbrake.stub(:notify)
    exception = 'Hey! you did something wrong!'

    job = VoteEmailJob.new(vote.id, :test_message)
    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end
end

describe VoteEmailJob, '#perform' do
  it 'sends an email if the vote exists and there is not another vote within the time window' do
    message = double(deliver: nil)
    UserMailer.stub(test_vote_email: message)
    vote = double(id: 123, has_no_other_votes_within_delay_window?: true)
    Vote.stub(find_by_id: vote)
    vote = create(:vote)

    VoteEmailJob.new(vote.id, :test_vote_email).perform

    expect(UserMailer).to have_received(:test_vote_email).once
    expect(message).to have_received(:deliver).once
  end

  it 'quietly fails and logs the error if the Vote is destroyed before the job runs' do
    UserMailer.stub(test_vote_email: nil)
    logger = double(error: 'blah')
    Rails.stub(logger: logger)
    Vote.stub(find_by_id: nil)
    vote_id = 0

    VoteEmailJob.new(vote_id, :test_vote_email).perform

    expect(logger).to have_received(:error).
      with("NOTE: VoteEmailJob cannot find Vote id=#{vote_id}")
    expect(UserMailer).not_to have_received(:test_vote_email)
  end

  it 'does not send an email if there is a new vote by the same user for the event in the time window' do
    UserMailer.stub(test_vote_email: nil)
    vote = double(id: 123, has_no_other_votes_within_delay_window?: false)
    Vote.stub(find_by_id: vote)

    VoteEmailJob.new(vote.id, :test_vote_email).perform

    expect(UserMailer).not_to have_received(:test_vote_email)
  end
end
