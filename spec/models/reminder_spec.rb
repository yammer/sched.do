require 'spec_helper'

describe Reminder do
  it { should belong_to(:sender) }
  it { should belong_to(:receiver) }

  it 'creates a delayed job' do
    ReminderCreatedJob.stubs(:enqueue)

    create(:reminder)

    ReminderCreatedJob.should have_received(:enqueue)
  end
end
