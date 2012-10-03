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

describe ReminderCreatedJob, '#perform' do
  it 'creates a Yammer activity message' do
    reminder = build_stubbed(:reminder)
    Reminder.stubs(find: reminder)
    reminder.stubs(:deliver)
    action = ReminderCreatedJob::ACTION

    ReminderCreatedJob.new(reminder.id).perform

    reminder.should have_received(:deliver).once
  end
end
