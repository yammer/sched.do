class Suggestion < ActiveRecord::Base
  validates :primary, presence: { message: 'This field is required' }

  attr_accessible :primary, :secondary, :event

  belongs_to :event
  has_many :votes, dependent: :destroy

  scope :with_votes,
    joins('LEFT OUTER JOIN votes ON votes.suggestion_id = suggestions.id').
    includes(:votes)

  def vote_count
    persisted_votes.size
  end

  def persisted_votes
    votes.select(&:persisted?)
  end
end
