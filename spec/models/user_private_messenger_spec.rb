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

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('vote')
    FakeYammer.message.should include(event.name)
    FakeYammer.message.should include(URL_HELPERS.event_url(event))
    FakeYammer.message.should_not include(event_owner.name)
  end

  it 'should include the event owner name if the sender is not the event owner' do
    invitation = build_stubbed(:invitation)

    UserPrivateMessenger.new(invitation).invite

    FakeYammer.message.should include(invitation.event.owner.name)
  end
end
