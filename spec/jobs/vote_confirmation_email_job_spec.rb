require 'spec_helper'

describe VoteConfirmationEmailJob, '.enqueue' do
  it 'enqueues the job' do
    vote = build_stubbed(:vote)

    VoteConfirmationEmailJob.enqueue(vote)

    should enqueue_delayed_job('VoteConfirmationEmailJob').
      with_attributes(vote_id: vote.id).
      priority(1)
  end
end

describe VoteConfirmationEmailJob, '#perform' do
  it 'emails a confirmation message to the voter' do
    mailer = stub('mailer', deliver: true)
    UserMailer.stubs vote_confirmation: mailer
    vote = build_stubbed(:vote)
    Vote.stubs find: vote

    VoteConfirmationEmailJob.new(vote.id).perform

    UserMailer.should have_received(:vote_confirmation).with(vote)
  end
end
