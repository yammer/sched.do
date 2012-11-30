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

  after_create :queue_invitation_created_job, unless: :skip_notification

  def self.invite_without_notification(event, invitee)
    create(
      event: event,
      invitee: invitee,
      skip_notification: true
    )
  end

  def deliver_invitation
    invitee.deliver_email_or_private_message(:invitation, sender, self)
  end

  def deliver_reminder_from(reminder_sender)
    if not invitee.voted_for_event?(event)
      invitee.deliver_email_or_private_message(:reminder, reminder_sender, self)
    end
  end

  private

  def queue_invitation_created_job
    InvitationCreatedJob.enqueue(self)
  end
end
