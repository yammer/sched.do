class VoteEmailJob < Struct.new(:vote_id, :email_type)
  DELAY = 3.minutes

  def self.enqueue(vote, email_type)
    job = new(vote.id, email_type)

    Delayed::Job.enqueue(job, run_at: DELAY.from_now)
  end

  def perform
    if vote && no_other_recent_votes
      UserMailer.send(email_type, vote).deliver
    end
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def vote
    @vote ||= find_vote || log_error_and_return_false
  end

  def find_vote
    Vote.find_by_id(vote_id)
  end

  def log_error_and_return_false
    log_error
    false
  end

  def log_error
    Rails.logger.error("NOTE: VoteEmailJob cannot find Vote id=#{vote_id}")
  end

  def no_other_recent_votes
    vote.has_no_other_votes_within_delay_window?
  end
end
