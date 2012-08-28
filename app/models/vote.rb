class Vote < ActiveRecord::Base
  VOTE_EMAIL_DELAY = 3.minutes
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :voter, polymorphic: true

  validates :suggestion_id, presence: true
  validates :voter_id, presence: true
  validates :voter_type, presence: true
  validates :suggestion_id, uniqueness: {
    scope: [:voter_type, :voter_id]
  }


  after_create :send_confirmation_email
  after_create :create_yammer_activity_for_new_vote

  def self.none
    where( id: nil)
  end

  def event
    suggestion.event
  end

  private

  def create_yammer_activity_for_new_vote
    voter.create_yammer_activity('vote', event)
  end

  def send_confirmation_email
    if no_recent_votes
      UserMailer.delay(run_at: VOTE_EMAIL_DELAY.from_now).vote_confirmation(self)
    end
  end

  private

  def no_recent_votes
    voter.
      votes.
      where(['id != ?', id]).
      where(['created_at > ?', VOTE_EMAIL_DELAY.ago]).
      empty?
  end
end
