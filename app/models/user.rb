class User < ActiveRecord::Base
  USERS_ENDPOINT = 'https://www.yammer.com/api/v1/users'

  serialize :extra, JSON
  attr_accessible :access_token, :encrypted_access_token, :name,
    :yammer_user_id, :yammer_staging
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events
  has_many :user_votes
  has_many :votes, through: :user_votes
  has_many :invitations, as: :invitee

  validates :name, presence: true
  validates :yammer_user_id, presence: true
  validates :encrypted_access_token, presence: true

  def self.create_with_auth(auth)
    create(yammer_user_id: auth[:yammer_user_id].to_s).tap do |user|
      user.access_token = auth[:access_token]
      user.yammer_staging = auth[:yammer_staging]
      user.fetch_yammer_user_data
      user.save!
    end
  end

  def self.find_or_create_with_auth(auth)
    find_by_yammer_user_id(auth[:yammer_user_id].to_s) ||
      create_with_auth(auth)
  end

  def able_to_edit?(event)
    event.user == self
  end

  def build_user_vote
    user_votes.new
  end

  def create_yammer_activity(action, event)
    ActivityCreator.new(self, action, event).create
  end

  def guest?
    false
  end

  def fetch_yammer_user_data
    response = yammer_user_data
    update_attributes(
      {
        email: response['contact']['email_addresses'].detect{|address| address['type'] == 'primary'}['address'],
        image: response['mugshot_url'],
        name: response['full_name'],
        nickname: response['name'],
        yammer_profile_url: response['web_url'],
        yammer_network_id: response['network_id'],
        extra: response
      },
      { without_protection: true }
    )
  end

  def in_network?(test_user)
    yammer_network_id == test_user.yammer_network_id
  end

  def image
    self[:image] || 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def notify(invitation)
    if invitation.sender.in_network?(invitation.invitee)
      PrivateMessager.new(invitation).deliver
    else
      UserMailer.delay.invitation(self, invitation.event)
    end
  end

  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def voted_for?(suggestion)
    vote_for_suggestion(suggestion).present?
  end

  def yammer_user?
    true
  end

  def yammer_endpoint
    yammer_staging ? "https://www.staging.yammer.com/" : "https://www.yammer.com/"
  end

  def yammer_user_data
    JSON.parse(
      RestClient.get yammer_endpoint +
      "api/v1/users/" +
      yammer_user_id +
      ".json?" + {
        access_token: access_token,
      }.to_query
    )
  end
end
