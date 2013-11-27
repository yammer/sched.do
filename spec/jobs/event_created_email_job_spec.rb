require 'spec_helper'

describe EventCreatedEmailJob, '.enqueue' do
  it 'enqueues the job' do
    event = build_stubbed(:event)
    Delayed::Job.stub(:enqueue)
    event_created_email_job = EventCreatedEmailJob.new(event.id)

    EventCreatedEmailJob.enqueue(event)

    expect(Delayed::Job).to have_received(:enqueue).with(event_created_email_job)
  end
end

describe EventCreatedEmailJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    event = build_stubbed(:event)
    Airbrake.stub(:notify)
    exception = 'Hey! you did something wrong!'

    job = EventCreatedEmailJob.new(event.id)
    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end
end

describe EventCreatedEmailJob, '#perform' do
  it 'emails a confirmation message to the event creator' do
    mailer = double(deliver: true)
    UserMailer.stub(event_created_confirmation: mailer)
    event = build_stubbed(:event)
    Event.stub(find: event)

    EventCreatedEmailJob.new(event.id).perform

    expect(UserMailer).to have_received(:event_created_confirmation).with(event)
  end
end
