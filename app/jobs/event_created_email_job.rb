class EventCreatedEmailJob < Struct.new(:event_id)
  def self.enqueue(event)
    job = new(event.id)

    Delayed::Job.enqueue(job)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    UserMailer.event_created_confirmation(event).deliver
  end

  private

  def event
    Event.find(event_id)
  end
end
