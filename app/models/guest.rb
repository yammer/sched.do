class Guest < ActiveRecord::Base
  attr_accessible :name, :email

  has_many :guest_votes
  has_many :votes, through: :guest_votes
  has_many :invitations, as: :invitee

  validates :email, presence: true
  validates :email, format: %r{^[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i
  validates :name, presence: true, on: :update

  def able_to_edit?(event)
    false
  end

  def build_user_vote
    guest_votes.new
  end

  def create_yammer_activity(action, event)
    nil
  end

  def guest?
    true
  end

  def notify(invitation)
    UserMailer.invitation(self, invitation.event).deliver
  end


  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def voted_for?(suggestion)
    vote_for_suggestion(suggestion).present?
  end

  def yammer_group_id
    nil
  end

  def yammer_user?
    false
  end

  def yammer_user_id
    nil
  end

  def yammer_staging
    false
  end
end
