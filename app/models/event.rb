class Event < ActiveRecord::Base
  NAME_MAX_LENGTH = 70

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'

  has_many :primary_suggestions, order: 'created_at'
  has_many :votes

  has_many :invitations
  has_many :users, through: :invitations, source: :invitee, source_type: 'User'
  has_many :guests, through: :invitations, source: :invitee, source_type: 'Guest'
  has_many :groups, through: :invitations, source: :invitee, source_type: 'Group'

  delegate :watermarked_image, to: :owner

  accepts_nested_attributes_for :primary_suggestions,
    reject_if: :reject_primary_suggestion?,
    allow_destroy: true

  before_validation :generate_uuid, on: :create
  before_validation :set_first_suggestion
  before_create :set_owner_watermark

  validates :name, presence: { message: 'This field is required' }
  validates :name, length: { maximum: NAME_MAX_LENGTH }
  validates :user_id, presence: true
  validates :uuid, presence: true

  validate :add_errors_if_no_suggestions

  after_create :invite_owner
  after_create :enqueue_event_created_jobs

  after_update :enqueue_event_updated_job

  def deliver_reminder_from(sender)
    invitations_without(sender).each do |invitation|
      invitation.deliver_reminder_from(sender)
    end
  end

  def invitees
    (users + guests).sort { |a, b| b.created_at <=> a.created_at }
  end

  def suggestions
    primary_suggestions
  end

  def to_param
    uuid
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.hex(4)
  end

  def set_first_suggestion
    primary_suggestions[0] ||= PrimarySuggestion.new
  end

  def add_errors_if_no_suggestions
    if lacks_suggestions?
      errors.add(
        :primary_suggestions,
        'An event must have at least one suggestion'
      )
    end
  end

  def lacks_suggestions?
    remaining_suggestions.none?
  end

  def set_owner_watermark
    File.open(Rails.root.join('public', 'logo-high-res.png')) do |file|
      owner.watermarked_image = file
    end
  end

  def remaining_suggestions
    primary_suggestions.reject do |s|
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

  def enqueue_event_updated_job
    ActivityCreatorJob.enqueue(self.owner, 'update', self)
  end

  def invitations_without(user)
    invitations.reject { |i| i.invitee == user }
  end

  def reject_primary_suggestion?(attributes)
     is_new_primary_suggestion?(attributes) &&
       is_primary_suggestion_present?(attributes) &&
       is_secondary_suggestion_present?(attributes)
  end

  def is_new_primary_suggestion?(attributes)
    attributes['id'].nil?
  end

  def is_primary_suggestion_present?(attributes)
    attributes['description'].empty? 
  end

  def is_secondary_suggestion_present?(attributes)
    attributes['secondary_suggestions_attributes'].nil? ||
    attributes['secondary_suggestions_attributes'].to_a[0][1]['description'].empty?
  end
end
