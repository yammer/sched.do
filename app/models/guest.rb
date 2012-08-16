class Guest < ActiveRecord::Base
  attr_accessible :name, :email
  attr_accessor :should_validate_name

  has_many :guest_votes
  has_many :votes, through: :guest_votes
  has_many :invitations, as: :invitee

  validates :email, presence: true
  validates :email, format: %r{^[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i
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

  def build_user_vote
    guest_votes.new
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

  def set_should_validate_name
    @should_validate_name = true
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
