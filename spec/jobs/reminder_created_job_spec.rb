require 'spec_helper'

describe ReminderCreatedJob, '.enqueue' do
  it 'enqueues the job' do
    reminder = build_stubbed(:reminder)
    Reminder.stubs(find: reminder)

    ReminderCreatedJob.enqueue reminder

    should enqueue_delayed_job('ReminderCreatedJob').
      with_attributes(reminder_id: reminder.id).
      priority(1)
  end
end

describe ReminderCreatedJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    reminder = build_stubbed(:reminder)
    Airbrake.stubs(:notify)
    exception = 'Hey! you did something wrong!'

    job = ReminderCreatedJob.new(reminder.id)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end

describe ReminderCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    reminder = build_stubbed(:reminder)
    Reminder.stubs(find: reminder)
    reminder.stubs(:deliver)

    ReminderCreatedJob.new(reminder.id).perform

    reminder.should have_received(:deliver).once
  end
end
