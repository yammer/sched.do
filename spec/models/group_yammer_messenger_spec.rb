require 'spec_helper'

describe GroupYammerMessenger, '#invite' do
  it 'sends a message' do
    invitation = build(:invitation_with_group, invitation_text: 'custom text')
    event = invitation.event

    GroupYammerMessenger.new(invitation.invitee).invite(invitation)

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.group_id).to eq invitation.invitee.yammer_group_id.to_s
    expect(FakeYammer.message).to include('vote')
    expect(FakeYammer.message).to include(invitation.invitation_text)
    expect(FakeYammer.message).to include(URL_HELPERS.event_url(event))
  end
end

describe GroupYammerMessenger, '#remind' do
  it 'sends a message with reminder text' do
    invitation = build_stubbed(:invitation_with_group)
    event = invitation.event

    GroupYammerMessenger.new(invitation.invitee).remind(event, event.owner)

    expect(FakeYammer.message).to include(
      "Reminder: Help me out by voting on #{event.name}"
    )
  end
end

describe GroupYammerMessenger, '#notify' do
  it 'sends a winner notification message' do
    event = build_stubbed(:event)
    recipient = build(:user)
    message = 'I have chosen this option'

     GroupYammerMessenger.new(recipient).notify(event, message)

    expect(FakeYammer.message).to include('group-event-winner-notification')
    expect(FakeYammer.message).to include(message)
  end
end
