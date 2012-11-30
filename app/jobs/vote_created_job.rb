class VoteCreatedJob < Struct.new(:vote_id)
  PRIORITY = 1
  ACTION = 'vote'

  def self.enqueue(vote)
    Delayed::Job.enqueue(new(vote.id), priority: PRIORITY)
  end

  def perform
    enqueue_activity_creator_job
    VoteConfirmationEmailJob.enqueue(vote)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def voter
    @voter ||= vote.voter
  end

  def vote
    @vote ||= Vote.find(vote_id)
  end

  def enqueue_activity_creator_job
    if voter.yammer_user?
      ActivityCreatorJob.enqueue(voter, ACTION, event)
    end
  end

  def event
    vote.event
  end
end
