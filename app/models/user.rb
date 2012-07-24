class User < ActiveRecord::Base
  serialize :extra, JSON
  attr_accessible :access_token, :encrypted_access_token, :name

  has_many :events
  has_many :user_votes
  has_many :votes, through: :user_votes
  has_many :invitations, as: :invitee

  validates :access_token, presence: true
  validates :encrypted_access_token, presence: true
  validates :name, presence: true
  validates :salt, presence: true
  validates :yammer_user_id, presence: true

  before_validation(on: :create) do
    set_salt_if_necessary
    set_encrypted_access_token
  end

  def self.create_from_params!(params)
    create!(
      {
        access_token: params[:info][:access_token],
        email: params[:info][:email],
        image: params[:info][:image],
        name: params[:info][:name],
        nickname: params[:info][:nickname],
        yammer_profile_url: params[:info][:yammer_profile_url],
        yammer_user_id: params[:uid],
        extra: params[:extra]
      },
      { without_protection: true }
    )
  end

  def self.find_and_update_from_yammer(params)
    user = User.find_by_access_token(params[:info][:access_token])

    if user
      user.update_yammer_info(params)
    end

    user
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

  def notify(invitation)
    PrivateMessage.new(invitation.event,
                       invitation.invitee,
                       invitation.message).create
  end

  def update_yammer_info(params)
    self.update_attributes(
      {
        access_token: params[:info][:access_token],
        email: params[:info][:email],
        image: params[:info][:image],
        name: params[:info][:name],
        nickname: params[:info][:nickname],
        yammer_profile_url: params[:info][:yammer_profile_url],
        yammer_user_id: params[:uid],
        extra: params[:extra]
      },
      { without_protection: true }
    )
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

  private

  def set_encrypted_access_token
    self.encrypted_access_token = Encrypter.new(access_token, salt).encrypt
  end

  def set_salt_if_necessary
    if salt.blank?
      self.salt = SaltGenerator.new.generate
    end
  end
end
