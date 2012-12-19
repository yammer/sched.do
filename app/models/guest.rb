class Guest < ActiveRecord::Base
  attr_accessible :name, :email, :has_ever_logged_in

  has_many :invitations, as: :invitee
  has_many :votes, as: :voter

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: true
  validates :email, email: true
  validates :name, presence: true, if: :has_ever_logged_in?

  def self.create_without_name_validation(email)
    Guest.new.tap do |guest|
      guest.email = email
      guest.save
    end
  end

  def self.initialize_with_name_and_email(params)
    guest = find_or_initialize_by_email(params[:guest][:email].downcase)
    guest.name = params[:guest][:name]
    guest
  end

  def able_to_edit?(event)
    false
  end

  def image
    'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def invite(invitation)
    Messenger.new(invitation).invite
  end

  def set_has_ever_logged_in
    self.update_attributes!(has_ever_logged_in: true)
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
