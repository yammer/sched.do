require 'spec_helper'

describe RemindersController, '#create' do
  it 'creates a Reminder' do
    user = create(:user)
    event = create(:event)
    sign_in_as(user)
    reminder = Reminder.new
    Reminder.stubs(new: reminder)
    Reminder.any_instance.stubs(:save)

    post :create, reminder: { receiver_id: '123' }, event_id: event

    Reminder.should have_received(:new)
    Reminder.any_instance.should have_received(:save)
  end

  it 'sets the Reminder sender to current_user' do
    user = create(:user)
    event = create(:event)
    sign_in_as(user)
    reminder = Reminder.new
    Reminder.stubs(new: reminder)
    Reminder.any_instance.stubs(:save)

    post :create, reminder: { receiver_id: '123' }, event_id: event

    reminder.sender.should == user
    Reminder.any_instance.should have_received(:save)
  end

  context 'the Reminder is successfully saved' do
    it 'adds a message to flash[:notice]' do
      user = create(:user)
      event = create(:event)
      sign_in_as(user)
      reminder = Reminder.new
      Reminder.stubs(create: reminder)
      Reminder.any_instance.stubs(:save).returns true

      post :create, reminder: { receiver_id: '123' }, event_id: event

      flash[:notice].should match /sent/
    end
  end

  context 'the Reminder is not saved' do
    it 'adds a message to flash[:error]' do
      user = create(:user)
      event = create(:event)
      sign_in_as(user)
      reminder = Reminder.new
      Reminder.stubs(create: reminder)

      Reminder.any_instance.stubs(:save)

      post :create, reminder: { receiver_id: '123' }, event_id: event

      flash[:error].should match /error/
    end
  end
end
