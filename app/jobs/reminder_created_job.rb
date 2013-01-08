class ReminderCreatedJob < Struct.new(:reminder_id)
  PRIORITY = 1

  def self.enqueue(reminder)
    Delayed::Job.enqueue(new(reminder.id), priority: PRIORITY)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    reminder.deliver
  end

  private

  def reminder
    @reminder ||= Reminder.find(reminder_id)
  end

  def sender
    @sender ||= reminder.sender
  end
end
