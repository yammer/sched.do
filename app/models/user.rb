class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events
  has_many :votes, as: :voter
  has_many :invitations, as: :invitee

  before_validation :strip_email_whitespace
  before_create :usurp_existing_guest_accounts

  validates :email, email: true
  validates :name, presence: true
  validates :yammer_user_id, presence: true

  validates :encrypted_access_token, uniqueness: true, allow_nil: true

  def usurp_existing_guest_accounts
    guest = Guest.find_by_email(email)

    if guest
      guest.invitations.reduce(self.invitations, :<<)
      guest.destroy
    end
  end

  has_attached_file :watermarked_image,
    styles: { original: '100x100' },
    processors: [:thumbnail, :watermark]

  def able_to_edit?(event)
    event.owner == self
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
      watermarked_image = File.open(Rails.root.join('public', 'logo-high-res.png'))
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
    if access_token.nil?
      raise 'Yammer client requires an access_token!'
    end

    @yam ||= Yam.new(access_token, yammer_endpoint)
  end

  private

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

  def yammer_endpoint
    yammer_staging ? YAMMER_STAGING_ENDPOINT : YAMMER_ENDPOINT
  end

  def strip_email_whitespace
    self.email = email.try(:strip)
  end
end
