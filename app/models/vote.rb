class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :voter, polymorphic: true

  validates :suggestion_id, presence: true
  validates :suggestion_id, uniqueness: { scope: [:voter_type, :voter_id] }
  validates :voter_id, presence: true
  validates :voter_type, presence: true

  after_create :queue_vote_created_job, :cache_vote_on_invitation

  def self.none
    where(id: nil)
  end

  def has_no_other_votes_within_delay_window?
    voter.
      votes.
      joins(suggestion: :event).
      where(['votes.id != ?', self.id]).
      where(['events.id = ?', self.event.id]).
      where(['votes.created_at >= ?', self.created_at]).
      where(['votes.created_at <= ?', (self.created_at + delay_window)]).
      empty?
  end

  def event
    suggestion.event
  end

  private

  def delay_window
    VoteConfirmationEmailJob::DELAY
  end

  def queue_vote_created_job
    VoteCreatedJob.enqueue(self)
  end

  def cache_vote_on_invitation
    invitation = voter.invitations.where(event_id: event.id).first!
    invitation.update_attributes!(vote: self)
  end
end
