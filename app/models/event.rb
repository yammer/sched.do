class Event < ActiveRecord::Base
  NAME_MAX_LENGTH = 70

  attr_accessible :name, :suggestion, :suggestions_attributes, :uuid

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'

  has_many :suggestions
  has_many :votes, through: :suggestions

  has_many :invitations
  has_many :users, through: :invitations, source: :invitee, source_type: 'User'
  has_many :guests, through: :invitations, source: :invitee, source_type: 'Guest'
  has_many :groups, through: :invitations, source: :invitee, source_type: 'Group'

  accepts_nested_attributes_for :suggestions, reject_if: :all_blank,
    allow_destroy: true

  before_validation :generate_uuid, on: :create
  before_validation :set_first_suggestion

  validates :name, presence: { message: 'This field is required' }
  validates :name, length: { maximum: NAME_MAX_LENGTH }
  validates :user_id, presence: true
  validates :uuid, presence: true

  validate :add_errors_if_no_suggestions

  after_create :invite_owner
  after_create :enqueue_event_created_jobs

  def deliver_reminder_from(sender)
    invitations_without(sender).each do |invitation|
      invitation.deliver_reminder_from(sender)
    end
  end

  def invitees
    (users + guests).sort { |a, b| b.created_at <=> a.created_at }
  end

  def to_param
    uuid
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.hex(4)
  end

  def set_first_suggestion
    suggestions[0] ||= Suggestion.new
  end

  def add_errors_if_no_suggestions
    if lacks_suggestions?
      errors.add(:suggestions, 'An event must have at least one suggestion')
    end
  end

  def lacks_suggestions?
    remaining_suggestions.none?
  end

  def remaining_suggestions
    suggestions.reject do |s|
      s.marked_for_destruction?
    end
  end

  def invite_owner
    Invitation.new(event: self, invitee: owner).invite_without_notification
  end

  def enqueue_event_created_jobs
    EventCreatedEmailJob.enqueue(self)
    ActivityCreatorJob.enqueue(self.owner, 'create', self)
  end

  def invitations_without(user)
    invitations.reject { |i| i.invitee == user }
  end
end
