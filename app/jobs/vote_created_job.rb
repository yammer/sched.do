class VoteCreatedJob < Struct.new(:vote_id)
  PRIORITY = 1
  ACTION = 'vote'

  def self.enqueue(vote)
    Delayed::Job.enqueue(new(vote.id), priority: PRIORITY)
  end

  def perform
    if vote
      create_activity_message
      send_vote_confirmation_email
    end
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def vote
    @vote ||= Vote.find_by_id(vote_id)
  end

  def create_activity_message
    if voter.yammer_user?
      ActivityCreatorJob.enqueue(voter, ACTION, event)
    end
  end

  def voter
    @voter ||= vote.voter
  end

  def send_vote_confirmation_email
    VoteConfirmationEmailJob.enqueue(vote)
  end

  def event
    vote.event
  end
end
