require 'spec_helper'

describe YammerMessenger, '#invite' do
  it 'sends an invitation message' do
    invitation = build(:invitation)
    event = invitation.event

    YammerMessenger.new(invitation.invitee).invite(invitation)

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include('vote')
    expect(FakeYammer.message).to include(invitation.invitation_text)
    expect(FakeYammer.message).to include('event-invitation')
    expect(FakeYammer.message).to include(URL_HELPERS.event_url(event))
  end
end

describe YammerMessenger, '#remind' do
  it 'sends a reminder message' do
    event = build_stubbed(:event)
    recipient = build(:user)
    sender = build(:user)

    YammerMessenger.new(recipient).remind(event, sender)

    expect(FakeYammer.message).to include('event-reminder')
    expect(FakeYammer.message).to include(
      "Reminder: Help out #{event.owner.name} by voting on #{event.name}")
  end
end

describe YammerMessenger, '#notify' do
  it 'sends a winner notification message' do
    event = build_stubbed(:event)
    recipient = build(:user)
    message = 'I have chosen this option'

    YammerMessenger.new(recipient).notify(event, message)

    expect(FakeYammer.message).to include('winner-notification')
    expect(FakeYammer.message).to include(message)
  end
end
