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
      GroupYammerMessenger.any_instance.stubs(:deliver)

      event_closer(invitation.event).process
      work_off_delayed_jobs

      expect(GroupYammerMessenger.any_instance).to have_received(:deliver)
    end

    it 'sends a personal notification' do
      event = create(:event)
      YammerMessenger.any_instance.stubs(:deliver)

      event_closer(event).process
      work_off_delayed_jobs

      expect(YammerMessenger.any_instance).to have_received(:deliver)
    end

    it 'sends an email' do
      invitation = create(:invitation_with_guest)
      Messenger.any_instance.stubs(:notify)

      event_closer(invitation.event).process
      work_off_delayed_jobs

      expect(Messenger.any_instance).to have_received(:notify)
    end

    it 'sends an email to the owner' do
      event = create(:event)
      fake_email = stub(:deliver)
      UserMailer.stubs(:closed_event_notification).returns(fake_email)

      event_closer(event).process
      work_off_delayed_jobs

      expect(UserMailer).to have_received(:closed_event_notification).
        with(event)
    end

    def event_closer(event)
      EventCloser.new(
        event,
        winning_suggestion_id: event.suggestions.first.id,
        winning_suggestion_type: event.suggestions.first.class.name,
        message: 'I have chosen this suggestion'
      )
    end
  end
end
