class Vote < ActiveRecord::Base
  belongs_to :event
  belongs_to :suggestion, polymorphic: true
  belongs_to :voter, polymorphic: true

  validates :suggestion_id, presence: true
  validates :suggestion_id, uniqueness: { scope: [:voter_type, :voter_id, :suggestion_type] }
  validates :suggestion_type, presence: true
  validates :voter_id, presence: true
  validates :voter_type, presence: true

  after_create :queue_vote_created_job, :cache_vote_on_invitation

  def change_deleted_status
    if vote_is_active
      delete_vote
    else
      un_delete_vote
    end
  end

  def has_no_other_votes_within_delay_window?
    voter.
      votes.
      joins(:event).
      where('votes.id != ?', self.id).
      where('events.id = ?', self.event.id).
      where('votes.created_at >= ?', self.created_at).
      where('votes.created_at <= ?', (self.created_at + delay_window)).
      empty?
  end

  private

  def cache_vote_on_invitation
    invitation = voter.invitations.where(event_id: event.id).first!
    invitation.update_attributes!(vote: self)
  end

  def delay_window
    VoteEmailJob::DELAY
  end

  def delete_vote
    self.update_attributes(deleted_at: Time.zone.now)
  end

  def queue_vote_created_job
    VoteCreatedJob.enqueue(self)
  end

  def un_delete_vote
    self.update_attributes(deleted_at: nil)
  end

  def vote_is_active
    deleted_at == nil
  end
end
