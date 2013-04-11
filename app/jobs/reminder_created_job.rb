class ReminderCreatedJob < Struct.new(:reminder_id)
  PRIORITY = 1

  def self.enqueue(reminder)
    Delayed::Job.enqueue(new(reminder.id), priority: PRIORITY)
  end

  def perform
    reminder.deliver
  end

  def error(job, exception)
    unless ExceptionSilencer.is_rate_limit?(exception)
      Airbrake.notify(exception)
    end
  end

  def failure(job)
    Airbrake.notify(error_message: "Job failure: #{job.last_error}")
  end

  private

  def reminder
    @reminder ||= Reminder.find(reminder_id)
  end
end
