class Guest < ActiveRecord::Base
  attr_accessible :name, :email
  attr_accessor :should_validate_name

  has_many :invitations, as: :invitee
  has_many :votes, as: :voter

  validates :email, presence: true
  validates :email, email: true
  validates :name, presence: true, if: :should_validate_name

  after_initialize :set_should_validate_name

  def self.create_without_name_validation(email)
    Guest.new.tap do |guest|
      guest.email = email
      guest.should_validate_name = false
      guest.save
    end
  end

  def able_to_edit?(event)
    false
  end

  def create_yammer_activity(action, event)
    nil
  end

  def guest?
    true
  end

  def image
    'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def notify(invitation)
    UserMailer.delay.invitation(self, invitation.event)
  end

  def deliver_email_or_private_message(message, sender, object)
    UserMailer.send(message, sender, object).deliver
  end

  def set_should_validate_name
    @should_validate_name = true
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
