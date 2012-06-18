class Suggestion < ActiveRecord::Base
  validates :description, presence: true

  attr_accessible :description, :event

  belongs_to :event
  has_many :votes, dependent: :destroy

  def vote_count
    votes.select(&:persisted?).size
  end
end
