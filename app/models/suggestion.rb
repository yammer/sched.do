class Suggestion < ActiveRecord::Base
  validates :primary, presence: { message: 'This field is required' }

  attr_accessible :primary, :secondary, :event

  belongs_to :event
  has_many :votes, dependent: :destroy

  def vote_count
    persisted_votes.size
  end

  def user_voted?(user)
    persisted_votes.any?{|vote| vote.user == user }
  end

  def persisted_votes
    votes.select(&:persisted?)
  end
end
