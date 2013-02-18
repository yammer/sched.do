require 'spec_helper'

describe Reminder do
  it { expect(subject).to belong_to(:sender) }
  it { expect(subject).to belong_to(:receiver) }
end

describe Reminder do
  it 'creates a delayed job after create' do
    ReminderCreatedJob.stubs(:enqueue)

    create(:reminder)

    expect(ReminderCreatedJob).to have_received(:enqueue)
  end
end

describe Reminder, '#deliver' do
  it 'delivers the reminders' do
    event = create(:event)
    reminder = create(:reminder, receiver: event)
    Event.any_instance.stubs(:deliver_reminder_from)

    reminder.deliver

    expect(Event.any_instance).to have_received(:deliver_reminder_from)
  end
end
