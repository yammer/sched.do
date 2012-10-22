class EventCreatedJob < Struct.new(:event_id)
  PRIORITY = 1
  ACTION = 'create'

  def self.enqueue(event)
    Delayed::Job.enqueue new(event.id), priority: PRIORITY
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    UserMailer.event_created_confirmation(event).deliver
    ActivityCreator.new(user, ACTION, event).create
  end

  private

  def event
    Event.find(event_id)
  end

  def user
    event.owner
  end
end
