require 'spec_helper'

describe EventCloser, '#process' do
  context 'with existing closed poll' do
    it 'does not send out notifications' do
      event = build(:closed_event)
      event_closer = EventCloser.new(event, message: 'hello')
      event_closer.stub(:send_notifications)

      event_closer.process

      expect(event_closer).not_to have_received(:send_notifications)
    end
  end

  context 'with an open poll' do
    it 'sends a group notification' do
      invitation = create(:invitation_with_group)
      group_yammer_messenger = double(notify: nil)
      GroupYammerMessenger.stub(new: group_yammer_messenger)

      event_closer(invitation.event).process
      work_off_delayed_jobs

      expect(group_yammer_messenger).to have_received(:notify)
    end

    it 'sends a personal notification' do
      event = create(:event)
      yammer_messenger = double(notify: nil)
      YammerMessenger.stub(new: yammer_messenger)

      event_closer(event).process
      work_off_delayed_jobs

      expect(yammer_messenger).to have_received(:notify)
    end

    it 'sends an email' do
      invitation = create(:invitation_with_guest)
      messenger = double(notify: nil)
      Messenger.stub(new: messenger)

      event_closer(invitation.event).process
      work_off_delayed_jobs

      expect(messenger).to have_received(:notify)
    end

    it 'sends an email to the owner' do
      event = create(:event)
      fake_email = double(deliver: nil)
      UserMailer.stub(closed_event_notification: fake_email)

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
