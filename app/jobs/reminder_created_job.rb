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

  def sender
    reminder.sender
  end

  def configure_yammer
    Yam.configure do |config|
      config.oauth_token = sender.access_token

      if sender.yammer_staging
        config.endpoint = YAMMER_STAGING_ENDPOINT
      end
    end
  end
end
