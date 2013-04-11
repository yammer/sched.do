require 'spec_helper'

describe EventCloser, '#process' do
  context 'with existing closed poll' do
    it 'does not send out notifications' do
      event = build(:closed_event)
      event_closer = EventCloser.new(event, message: 'hello')
      event_closer.stubs(:send_notifications)

      event_closer.process

      expect(event_closer).to have_received(:send_notifications).never
    end
  end

  context 'with an open poll' do
    it 'sends a group notification' do
      invitation = create(:invitation_with_group)
      event_closer = EventCloser.new(invitation.event, message: 'hello')
      GroupYammerMessenger.any_instance.stubs(:deliver)

      event_closer.process
      work_off_delayed_jobs

      expect(GroupYammerMessenger.any_instance).to have_received(:deliver)
    end

    it 'sends a personal notification' do
      event = create(:event)
      event_closer = EventCloser.new(event, message: 'hello')
      YammerMessenger.any_instance.stubs(:deliver)

      event_closer.process
      work_off_delayed_jobs

      expect(YammerMessenger.any_instance).to have_received(:deliver)
    end

    it 'sends an email' do
      invitation = create(:invitation_with_guest)
      event_closer = EventCloser.new(invitation.event, message: 'hello')
      Messenger.any_instance.stubs(:notify)

      event_closer.process
      work_off_delayed_jobs

      expect(Messenger.any_instance).to have_received(:notify)
    end
  end
end
