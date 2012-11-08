class ReminderCreatedJob < Struct.new(:reminder_id)
  PRIORITY = 1

  def self.enqueue(reminder)
    Delayed::Job.enqueue new(reminder.id), priority: PRIORITY
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    configure_yammer
    reminder.deliver
  end

  private

  def reminder
    Reminder.find(reminder_id)
  end

  def configure_yammer
    Yam.configure do |config|
      config.oauth_token = reminder.sender.access_token
      config.endpoint = reminder.sender.yammer_endpoint + "/api/v1"
    end
  end
end
