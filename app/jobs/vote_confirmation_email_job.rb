class VoteConfirmationEmailJob < Struct.new(:vote_id)
  PRIORITY = 1
  DELAY = 3.minutes

  def self.enqueue(vote)
    Delayed::Job.enqueue(
      new(vote.id),
      run_at: DELAY.from_now,
      priority: PRIORITY
    )
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    if no_votes_within_delay_window
      UserMailer.vote_confirmation(vote).deliver
    end
  end

  def no_votes_within_delay_window
    voter.
      votes.
      joins(suggestion: :event).
      where(['votes.id != ?', vote.id]).
      where(['events.id = ?',  vote.event.id]).
      where(['votes.created_at >= ?', vote.created_at]).
      where(['votes.created_at <= ?', (vote.created_at + DELAY)]).
      empty?
  end

  private

  def vote
    Vote.find(vote_id)
  end

  def voter
    vote.voter
  end
end
