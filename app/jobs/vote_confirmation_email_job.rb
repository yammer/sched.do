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

  def perform
    if vote && no_other_recent_votes
      send_confirmation_email
    end
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def vote
    found_vote || log_error_and_return_false
  end

  def found_vote
    Vote.find_by_id(vote_id)
  end

  def log_error_and_return_false
    log_error
    return false
  end

  def log_error
    Rails.logger.
      error "NOTE: VoteConfirmationEmailJob cannot find Vote id=#{vote_id}"
  end

  def no_other_recent_votes
    vote.has_no_other_votes_within_delay_window?
  end

  def send_confirmation_email
    UserMailer.vote_confirmation(vote).deliver
  end
end
