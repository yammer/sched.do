class ReminderCreatedJob < Struct.new(:reminder_id)
  include YammerRateLimited

  def self.enqueue(reminder)
    job = new(reminder.id)

    Delayed::Job.enqueue(job)
  end

  def perform
    reminder = Reminder.find(reminder_id)
    reminder.deliver
  end
end
