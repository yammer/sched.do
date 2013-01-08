require 'spec_helper'

describe VoteEmailJob, '.enqueue' do
  it 'enqueues the job' do
    Timecop.freeze do
      vote = build_stubbed(:vote)
      Delayed::Job.stubs(:enqueue)
      vote_email_job = VoteEmailJob.new(vote.id, :test_vote_email)
      priority = 1
      delay = 3.minutes

      VoteEmailJob.enqueue(vote, :test_vote_email)

      Delayed::Job.should have_received(:enqueue).
        with(vote_email_job, priority: priority, run_at: delay.from_now)
    end
  end
end

describe VoteEmailJob, '#error' do
  it 'sends Airbrake an exception if the job fails' do
    vote = build_stubbed(:vote)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = VoteEmailJob.new(vote.id, :test_message)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe VoteEmailJob, '#perform' do
  it 'sends an email if the vote exists and there is not another vote within the time window' do
    message = stub(deliver: nil)
    UserMailer.stubs(test_vote_email: message)
    Vote.any_instance.stubs(:has_no_other_votes_within_delay_window?).returns(true)
    vote = create(:vote)
    Vote.stubs(find_by_id: vote)

    VoteEmailJob.new(vote.id, :test_vote_email).perform

    UserMailer.should have_received(:test_vote_email).once
    message.should have_received(:deliver).once
  end

  it 'quietly fails and logs the error if the Vote is destroyed before the job runs' do
    UserMailer.stubs(test_vote_email: nil)
    fake_logger = stub(error: 'blah')
    Rails.stubs(logger: fake_logger)
    Vote.stubs(find_by_id: nil)
    vote_id = 0

    VoteEmailJob.new(vote_id, :test_vote_email).perform

    fake_logger.should have_received(:error).
      with("NOTE: VoteEmailJob cannot find Vote id=#{vote_id}")
    UserMailer.should have_received(:test_vote_email).never
  end

  it 'does not send an email if there is a new vote by the same user for the event in the time window' do
    UserMailer.stubs(test_vote_email: nil)
    Vote.any_instance.stubs(:has_no_other_votes_within_delay_window?).returns(false)
    vote = create(:vote)
    Vote.stubs(find_by_id: vote)

    VoteEmailJob.new(vote.id, :test_vote_email).perform

    UserMailer.should have_received(:test_vote_email).never
  end
end
