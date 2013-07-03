class Guest < ActiveRecord::Base
  has_many :invitations, as: :invitee
  has_many :votes, as: :voter

  before_validation :normalize_email

  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, email: true
  validates :name, presence: true, if: :has_ever_logged_in?

  def image
    'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def invite(invitation)
    messenger.invite(invitation)
  end

  def is_admin?
    false
  end

  def remind(event, sender)
    messenger.remind(event, sender)
  end

  def notify(event, message)
    messenger.notify(event, message)
  end

  def vote_for_suggestion(suggestion)
    votes.
      where(
        deleted_at: nil,
        suggestion_id: suggestion.id,
        suggestion_type: suggestion.class.name
      ).
      first
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

  def messenger
    Messenger.new(self)
  end

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
