require 'spec_helper'

describe VoteCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    @vote = build_stubbed(:vote)

    VoteCreatedJob.enqueue @vote

    should enqueue_delayed_job('VoteCreatedJob').
      with_attributes(vote_id: @vote.id).
      priority(1)
  end
end

describe VoteCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    vote = build_stubbed(:vote)
    Vote.stubs find: vote
    event = vote.event
    activity_creator = stub('activity_creator', create: true)
    ActivityCreator.stubs(new: activity_creator)

    VoteCreatedJob.new(event.id).perform

    ActivityCreator.should have_received(:new).
      with(vote.voter, VoteCreatedJob::ACTION, event)
    activity_creator.should have_received(:create)
  end

  it 'enqueue a VoteConfirmationEmailJob' do
    vote = build_stubbed(:vote)
    Vote.stubs find: vote
    event = vote.event
    VoteConfirmationEmailJob.stubs(:enqueue)

    VoteCreatedJob.new(event.id).perform

    VoteConfirmationEmailJob.should have_received(:enqueue).with(vote)
  end

  # it 'does not send confirmation email to the voter right away' do
  #   mailer = stub('mailer', deliver: true)
  #   UserMailer.stubs(vote_confirmation: mailer)
  #   vote = build_stubbed(:vote)
  #   Vote.stubs find: vote

  #   VoteCreatedJob.new(vote.id).perform

  #   UserMailer.should have_received(:vote_confirmation).with(vote).never
  #   mailer.should have_received(:deliver).never
  # end



  # it 'emails a confirmation message to the voter' do
  #   mailer = stub('mailer', deliver: true)
  #   UserMailer.stubs vote_confirmation: mailer
  #   vote = build_stubbed(:vote)
  #   Vote.stubs find: vote

  #   VoteCreatedJob.new(vote.id).perform

  #   UserMailer.should have_received(:vote_confirmation).with(vote)
  # end
end
