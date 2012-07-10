class Event < ActiveRecord::Base
  attr_accessible :name, :suggestion, :suggestions_attributes, :message

  belongs_to :user
  has_many :suggestions
  has_many :invitations
  has_many :users, through: :invitations, source: :invitee, source_type: 'User'
  has_many :yammer_invitees, through: :invitations, source: :invitee, source_type: 'YammerInvitee'
  has_many :guests, through: :invitations, source: :invitee, source_type: 'Guest'
  has_many :groups, through: :invitations, source: :invitee, source_type: 'Group'

  validates :name, presence: { message: 'This field is required' }
  validates :user_id, presence: true

  accepts_nested_attributes_for :suggestions, reject_if: :all_blank,
    allow_destroy: true

  after_create :create_event_created_activity

  def invitees
    group = [user] + users + yammer_invitees + guests
    group.sort{|a, b| b.created_at <=> a.created_at }
  end

  def invitees_for_json
    invitees.map { |e| { name: e.name, email: e.email } }
  end

  def user_invited?(user)
    invitees.include?(user)
  end

  private

  def create_event_created_activity
    ActivityCreator.new(self.user, 'create', self).create
  end
end
