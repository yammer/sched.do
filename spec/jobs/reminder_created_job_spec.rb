require 'spec_helper'

describe ReminderCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    reminder = build_stubbed(:reminder)
    Reminder.stub(find: reminder)
    Delayed::Job.stub(:enqueue)
    reminder_created_job = ReminderCreatedJob.new(reminder.id)

    ReminderCreatedJob.enqueue(reminder)

    expect(Delayed::Job).to have_received(:enqueue).with(reminder_created_job)
  end
end

describe ReminderCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    reminder = build_stubbed(:reminder)
    Reminder.stub(find: reminder)
    reminder.stub(:deliver)

    ReminderCreatedJob.new(reminder.id).perform

    expect(reminder).to have_received(:deliver).once
  end
end

describe ReminderCreatedJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = ReminderCreatedJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stub(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end

  it 'does not send exception to Airbrake if the job errors due to rate limit' do
    job = ReminderCreatedJob.new
    exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
    Airbrake.stub(:notify)

    job.error(job, exception)

    expect(Airbrake).not_to have_received(:notify)
  end
end

describe ReminderCreatedJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = ReminderCreatedJob.new
    job_record = double(last_error: 'boom')
    Airbrake.stub(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).
      with(error_message: 'Job failure: boom')
  end
end
