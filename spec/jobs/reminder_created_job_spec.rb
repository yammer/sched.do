require 'spec_helper'

describe ReminderCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    reminder = build_stubbed(:reminder)
    Reminder.stubs(find: reminder)
    Delayed::Job.stubs(:enqueue)
    reminder_created_job = ReminderCreatedJob.new(reminder.id)
    priority = 1

    ReminderCreatedJob.enqueue(reminder)

    expect(Delayed::Job).to have_received(:enqueue).
      with(reminder_created_job, priority: priority)
  end
end

describe ReminderCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    reminder = build_stubbed(:reminder)
    Reminder.stubs(find: reminder)
    reminder.stubs(:deliver)

    ReminderCreatedJob.new(reminder.id).perform

    expect(reminder).to have_received(:deliver).once
  end
end

describe ReminderCreatedJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = ReminderCreatedJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end

  it 'does not send exception to Airbrake if the job errors due to rate limit' do
    job = ReminderCreatedJob.new
    exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).never
  end
end

describe ReminderCreatedJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = ReminderCreatedJob.new
    job_record = stub(last_error: 'boom')
    Airbrake.stubs(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).with('Job failure: boom')
  end
end
