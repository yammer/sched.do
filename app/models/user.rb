class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events, order: 'created_at DESC'
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

  def image
    self[:image] || 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def invite(invitation)
    messenger(invitation.sender).invite(invitation)
  end

  def remind(event, sender)
    messenger(sender).remind(event, sender)
  end

  def notify(event, message)
    messenger(event.owner).notify(event, message)
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

  def messenger(sender)
    if in_network?(sender)
      YammerMessenger.new(self)
    else
      Messenger.new(self)
    end
  end

  def yammer_endpoint
    "#{yammer_host}/api/v1/"
  end

  def yammer_host
    if yammer_staging
      Rails.configuration.yammer_staging_host
    else
      Rails.configuration.yammer_host
    end
  end

  def strip_email_whitespace
    self.email = email.try(:strip)
  end
end
