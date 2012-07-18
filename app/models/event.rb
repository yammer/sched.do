class Event < ActiveRecord::Base
  attr_accessible :name, :suggestion, :suggestions_attributes, :message, :uuid

  belongs_to :user
  has_many :suggestions
  has_many :invitations
  has_many :users, through: :invitations, source: :invitee, source_type: 'User'
  has_many :yammer_invitees, through: :invitations, source: :invitee, source_type: 'YammerInvitee'
  has_many :guests, through: :invitations, source: :invitee, source_type: 'Guest'
  has_many :groups, through: :invitations, source: :invitee, source_type: 'Group'

  validates :name, presence: { message: 'This field is required' }
  validates :user_id, presence: true
  validates :uuid, presence: true

  accepts_nested_attributes_for :suggestions, reject_if: :all_blank,
    allow_destroy: true

  after_create :create_yammer_activity_for_new_event
  before_validation :generate_uuid, :on => :create

  def invitees
    group = [user] + users + yammer_invitees + guests
    group.sort{|a, b| b.created_at <=> a.created_at }
  end

  def invitees_for_json
    invitees.map { |i| { name: i.name, email: i.email } }
  end

  def generate_uuid
    self.uuid = SecureRandom.hex(4)
  end

  def user_invited?(user)
    invitees.include?(user)
  end

  def to_param
    uuid
  end

  private

  def create_yammer_activity_for_new_event
    ActivityCreator.new(self.user, 'create', self).create
  end
end
