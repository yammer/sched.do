require 'spec_helper'

describe EventCreatedEmailJob, '.enqueue' do
  it 'enqueues the job' do
    event = build_stubbed(:event)

    EventCreatedEmailJob.enqueue(event)

    should enqueue_delayed_job('EventCreatedEmailJob').
      with_attributes(event_id: event.id).
      priority(1)
  end
end

describe EventCreatedEmailJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    event = build_stubbed(:event)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = EventCreatedEmailJob.new(event.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe EventCreatedEmailJob, '#perform' do
  it 'emails a confirmation message to the event creator' do
    mailer = stub('mailer', deliver: true)
    UserMailer.stubs(event_created_confirmation: mailer)
    event = build_stubbed(:event)
    Event.stubs(find: event)

    EventCreatedEmailJob.new(event.id).perform

    UserMailer.should have_received(:event_created_confirmation).with(event)
  end
end
