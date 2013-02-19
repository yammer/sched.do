class Guest < ActiveRecord::Base
  has_many :invitations, as: :invitee
  has_many :votes, as: :voter

  before_validation :normalize_email

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, email: true
  validates :name, presence: true, if: :has_ever_logged_in?

  def able_to_edit?(event)
    false
  end

  def image
    'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def invite(invitation)
    Messenger.new(invitation).invite
  end

  def remind(invitation, sender)
    Messenger.new(invitation, sender).remind
  end

  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def voted_for_suggestion?(suggestion)
    vote_for_suggestion(suggestion).present?
  end

  def voted_for_event?(event)
    votes_for_event(event).exists?
  end

  def votes_for_event(event)
    event.votes.where(voter_id: self, voter_type: self.class.name)
  end

  def yammer_group_id
    nil
  end

  def yammer_network_id
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

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
