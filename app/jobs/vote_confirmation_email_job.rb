class VoteConfirmationEmailJob < Struct.new(:vote_id)
  PRIORITY = 1

  def self.enqueue(vote)
    Delayed::Job.enqueue new(vote.id), priority: PRIORITY
  end

  def perform
    UserMailer.vote_confirmation(vote).deliver
  end

  private

  def vote
    Vote.find(vote_id)
  end
end
