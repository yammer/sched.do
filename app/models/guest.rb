class Guest < ActiveRecord::Base
  attr_accessible :name, :email

  has_many :guest_votes
  has_many :votes, through: :guest_votes

  validates :email, presence: true

  def guest?
    true
  end

  def yammer_user?
    false
  end

  def able_to_edit?(event)
    false
  end

  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def build_user_vote
    guest_votes.new
  end
end
