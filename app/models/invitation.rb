class Invitation < ActiveRecord::Base
  attr_accessible :event, :invitee, :event_id, :sender

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

  def invite
    if save
      queue_created_jobs
    end
  end

  def invite_without_notification
    save
  end

  def deliver_reminder_from(reminder_sender)
    if not invitee.voted_for_event?(event)
      invitee.remind(self, reminder_sender)
    end
  end

  private

  def queue_created_jobs
    send_invitation_created_message
    send_activity_message
  end

  def send_invitation_created_message
    InvitationCreatedMessageJob.enqueue(self)
  end

  def send_activity_message
    if sender.yammer_user?
      ActivityCreatorJob.enqueue(sender, 'invite', event)
    end
  end
end
