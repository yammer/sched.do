class ReminderCreatedJob < Struct.new(:reminder_id)
  PRIORITY = 1
  ACTION = 'create'

  def self.enqueue(reminder)
    Delayed::Job.enqueue new(reminder.id), priority: PRIORITY
  end

  def perform
    reminder.deliver
  end

  private

  def reminder
    Reminder.find(reminder_id)
  end
end
