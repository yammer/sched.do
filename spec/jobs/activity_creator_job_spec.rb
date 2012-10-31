require 'spec_helper'

describe ActivityCreatorJob, '.enqueue' do
  it 'enqueues the job' do
    event = build_stubbed(:event)

    ActivityCreatorJob.enqueue(event)

    should enqueue_delayed_job('ActivityCreatorJob').
      with_attributes(event_id: event.id).
      priority(1)
  end
end

describe ActivityCreatorJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    event = build_stubbed(:event)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = ActivityCreatorJob.new(event.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe ActivityCreatorJob, '#perform' do
  it 'creates a Yammer activity message' do
    event = build_stubbed(:event)
    Event.stubs(find: event)
    user = event.owner
    action = ActivityCreatorJob::ACTION
    activity_creator = stub('activity_creator', create: true)
    ActivityCreator.stubs(new: activity_creator)

    ActivityCreatorJob.new(event.id).perform

    ActivityCreator.should have_received(:new).with(user, action, event)
    activity_creator.should have_received(:create)
  end
end
