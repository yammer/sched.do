class VoteCreatedJob < Struct.new(:vote_id)
  PRIORITY = 1
  ACTION = 'vote'

  def self.enqueue(vote)
    Delayed::Job.enqueue(new(vote.id), priority: PRIORITY)
  end

  def perform
    voter.create_yammer_activity(ACTION, event)
    VoteConfirmationEmailJob.enqueue(vote)
  end

  private

  def event
    vote.event
  end

  def no_recent_votes
    voter.
      votes.
      where(['id != ?', vote.id]).
      where(['created_at > ?', VOTE_EMAIL_DELAY.ago]).
      where(['created_at < ?', vote.created_at]).
      empty?
  end

  def vote
    Vote.find(vote_id)
  end

  def voter
    vote.voter
  end
end
