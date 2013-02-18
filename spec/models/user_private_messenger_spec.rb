require 'spec_helper'

describe UserPrivateMessenger, '#invitation' do
  it 'sends the correct invitation' do
    event_owner = build_stubbed(:user)
    invitee = build_stubbed(:user)
    event = build_stubbed(:event, owner: event_owner)
    invitation = build(:invitation,
      event: event,
      invitee: invitee,
      sender: event_owner)

    UserPrivateMessenger.new(invitation).invite

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include('vote')
    expect(FakeYammer.message).to include(event.name)
    expect(FakeYammer.message).to include(URL_HELPERS.event_url(event))
    expect(FakeYammer.message).to_not include(event_owner.name)
  end

  it 'includes the event owner name if the sender is not the event owner' do
    invitation = build_stubbed(:invitation)

    UserPrivateMessenger.new(invitation).invite

    expect(FakeYammer.message).to include(invitation.event.owner.name)
  end
end
