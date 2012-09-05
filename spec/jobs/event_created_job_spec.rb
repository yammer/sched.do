require 'spec_helper'

describe EventCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    event = build_stubbed(:event)

    EventCreatedJob.enqueue(event)

    should enqueue_delayed_job('EventCreatedJob').
      with_attributes(event_id: event.id).
      priority(1)
  end
end

describe EventCreatedJob, '#perform' do
  it 'emails a confirmation message to the event creator' do
    mailer = stub('mailer', deliver: true)
    UserMailer.stubs event_created_confirmation: mailer
    event = build_stubbed(:event)
    Event.stubs(find: event)

    EventCreatedJob.new(event.id).perform

    UserMailer.should have_received(:event_created_confirmation).with(event)
  end

  it 'creates a Yammer activity message' do
    event = build_stubbed(:event)
    Event.stubs(find: event)
    user = event.user
    action = EventCreatedJob::ACTION
    activity_creator = stub('activity_creator', create: true)
    ActivityCreator.stubs(new: activity_creator)

    EventCreatedJob.new(event.id).perform

    ActivityCreator.should have_received(:new).with(user, action, event)
    activity_creator.should have_received(:create)
  end
end
