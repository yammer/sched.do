class Reminder < ActiveRecord::Base
  attr_accessible :receiver_id, :receiver_type

  belongs_to :sender, polymorphic: true
  belongs_to :receiver, polymorphic: true

  after_create :queue_reminder_created_job

  def deliver
    receiver.deliver_reminder_from(sender)
  end

  private

  def queue_reminder_created_job
    ReminderCreatedJob.enqueue(self)
  end
end
