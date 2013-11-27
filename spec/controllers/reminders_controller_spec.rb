require 'spec_helper'

describe RemindersController, '#create' do
  it 'creates a Reminder' do
    user = create(:user)
    event = create(:event)
    sign_in_as(user)
    reminder = double(save: true, 'sender=' => user)
    Reminder.stub(new: reminder)

    post :create, reminder: { receiver_id: '123' }, event_id: event

    expect(Reminder).to have_received(:new)
    expect(reminder).to have_received(:save)
  end

  it 'sets the Reminder sender to current_user' do
    ReminderCreatedJob.stub(:enqueue)
    user = create(:user)
    event = create(:event)
    sign_in_as(user)

    post :create,
      reminder: { receiver_id: '123', receiver_type: 'Guest' }, event_id: event

    reminder = Reminder.last
    expect(reminder.sender).to eq user
  end

  context 'the Reminder is successfully saved' do
    it 'adds a message to flash[:notice]' do
      ReminderCreatedJob.stub(:enqueue)
      user = create(:user)
      event = create(:event)
      sign_in_as(user)

      post :create,
        reminder: { receiver_id: '123', receiver_type: 'Guest' }, event_id: event

      expect(flash[:notice]).to match(/sent/)
    end
  end

  context 'the Reminder is not saved' do
    it 'adds a message to flash[:error]' do
      user = create(:user)
      event = create(:event)
      sign_in_as(user)
      reminder = Reminder.new
      Reminder.stub(create: reminder)
      Reminder.any_instance.stub(:save)

      post :create, reminder: { receiver_id: '123' }, event_id: event

      expect(flash[:error]).to match(/error/)
    end
  end
end
