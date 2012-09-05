class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :voter, polymorphic: true

  validates :suggestion_id, presence: true
  validates :voter_id, presence: true
  validates :voter_type, presence: true
  validates :suggestion_id, uniqueness: {
    scope: [:voter_type, :voter_id]
  }

  after_create :queue_vote_created_job

  def self.none
    where(id: nil)
  end

  def event
    suggestion.event
  end

  private

  def queue_vote_created_job
    VoteCreatedJob.enqueue(self)
  end
end
