class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events
  has_many :votes, as: :voter
  has_many :invitations, as: :invitee

  before_validation :strip_email_whitespace

  validates :email, email: true
  validates :encrypted_access_token, presence: true
  validates :name, presence: true
  validates :yammer_user_id, presence: true

  has_attached_file :watermarked_image,
    styles: { original: '100x100' },
    processors: [:thumbnail, :watermark]

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
        yammer_network_name: response[:network_name],
        extra: response
      },
      { without_protection: true }
    )
  end

  def image
    self[:image] || 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def invite(invitation)
    get_messenger(invitation, invitation.sender).invite
  end

  def remind(invitation, sender)
    get_messenger(invitation, sender).remind
  end

  def to_s
    name
  end

  def update_watermark
    if watermarked_image
      watermarked_image = File.open(Rails.root.join('public', 'logo.png'))
    end
  end

  def vote_for_suggestion(suggestion)
    votes.
      where(
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

  def watermark
    image
  end

  def yammer_user?
    true
  end

  def yammer_group_id
    nil
  end

  def yammer_client
    @yam ||= Yam.new(access_token, yammer_endpoint)
  end

  private

  def yammer_user_data
    yammer_client.get("/users/#{yammer_user_id}")
  end

  def associate_each_invitation_with(guest)
    guest.invitations.each do |invitation|
      self.invitations << invitation
    end
  end

  def in_network?(test_user)
    yammer_network_id == test_user.yammer_network_id
  end

  def get_messenger(invitation, sender)
    if in_network?(sender)
      return UserPrivateMessenger.new(invitation, sender)
    else
      return Messenger.new(invitation, sender)
    end
  end

  def parse_email_from_response(response)
    response['contact']['email_addresses'].
      detect{ |address| address['type'] == 'primary' }['address']
  end

  def yammer_endpoint
    yammer_staging ? YAMMER_STAGING_ENDPOINT : YAMMER_ENDPOINT
  end

  def strip_email_whitespace
    self.email = email.try(:strip)
  end
end
