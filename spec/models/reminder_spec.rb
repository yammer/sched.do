require 'spec_helper'

describe Reminder do
  it { should belong_to(:sender) }
  it { should belong_to(:receiver) }
end

describe Reminder do
  it 'creates a delayed job after create' do
    ReminderCreatedJob.stubs(:enqueue)

    create(:reminder)

    ReminderCreatedJob.should have_received(:enqueue)
  end
end

describe Reminder, '#deliver' do
  it 'delivers the reminders' do
    event = create(:event)
    reminder = create(:reminder, receiver: event)
    Event.any_instance.stubs(:deliver_reminder_from)

    reminder.deliver

    Event.any_instance.should have_received(:deliver_reminder_from)
  end
end
