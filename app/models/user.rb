class User < ActiveRecord::Base
  serialize :extra, JSON
  attr_accessible :access_token, :encrypted_access_token, :name,
    :yammer_user_id, :yammer_staging
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events
  has_many :votes, as: :voter
  has_many :invitations, as: :invitee

  strip_attributes only: [:email]

  validates :email, email: true
  validates :encrypted_access_token, presence: true
  validates :name, presence: true
  validates :yammer_user_id, presence: true

  def able_to_edit?(event)
    event.owner == self
  end

  def associate_guest_invitations
    guest = Guest.find_by_email(email)

    if guest
      associate_each_invitation_with(guest)
      guest.destroy
    end
  end

  def expire_token
    update_attributes(access_token: 'EXPIRED')
  end

  def guest?
    false
  end

  def fetch_yammer_user_data
    response = yammer_user_data
    update_attributes(
      {
        email: parse_email_from_response(response),
        image: response[:mugshot_url],
        name: response[:full_name],
        nickname: response[:name],
        yammer_profile_url: response[:web_url],
        yammer_network_id: response[:network_id],
        extra: response
      },
      { without_protection: true }
    )
  end

  def image
    self[:image] || 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def deliver_email_or_private_message(message, sender, object)
    if in_network?(sender)
      PrivateMessenger.new(
        recipient: self,
        message: message,
        sender: sender,
        message_object: object
      ).deliver
    else
      UserMailer.send(message, sender, object).deliver
    end
  end

  def reset_token
    update_attributes(access_token: 'RESET')
  end

  def to_s
    name
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

  def yammer_user?
    true
  end

  def yammer_group_id
    nil
  end

  def yammer_user_data
    Yam.get("/users/#{yammer_user_id}")
  end

  private

  def associate_each_invitation_with(guest)
    guest.invitations.each do |invitation|
      self.invitations << invitation
    end
  end

  def in_network?(test_user)
    yammer_network_id == test_user.yammer_network_id
  end

  def parse_email_from_response(response)
    response['contact']['email_addresses'].
      detect{ |address| address['type'] == 'primary' }['address']
  end
end
