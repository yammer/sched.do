class Invitation < ActiveRecord::Base
  attr_accessor :skip_notification
  attr_accessible :event, :invitee, :event_id, :skip_notification, :sender

  belongs_to :event
  belongs_to :invitee, polymorphic: true
  belongs_to :sender, polymorphic: true

  accepts_nested_attributes_for :invitee

  validates :event_id, presence: true
  validates :invitee_type, presence: true
  validates :invitee_id, presence: { message: 'is invalid' }
  validates :invitee_id, uniqueness: {
    message: 'has already been invited',
    scope: [:invitee_type, :event_id]
  }

  after_create :queue_invitation_created_jobs, unless: :skip_notification

  def self.invite_without_notification(event, invitee)
    create(
      event: event,
      invitee: invitee,
      skip_notification: true
    )
  end

  def deliver_reminder_from(reminder_sender)
    if not invitee.voted_for_event?(event)
      invitee.remind(self, reminder_sender)
    end
  end

  private

  def queue_invitation_created_jobs
    send_invitation_created_messages
    send_activity_message
  end

  def send_invitation_created_messages
    InvitationCreatedMessageJob.enqueue(self)
  end

  def send_activity_message
    if sender.yammer_user?
      ActivityCreatorJob.enqueue(sender, 'invite', event)
    end
  end
end
