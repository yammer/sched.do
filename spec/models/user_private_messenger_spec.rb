require 'spec_helper'

describe UserPrivateMessenger, '#invitation' do
  it 'sends the correct invitation' do
    event_owner = create(:user)
    invitee = create(:user)
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: invitee)

    UserPrivateMessenger.new(invitation).invite

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('vote')
    FakeYammer.message.should include(event_owner.name)
  end
end

describe UserPrivateMessenger, '#reminder' do
  it 'sends the correct reminder' do
    event_owner = create(:user)
    invitee = create(:user)
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: invitee)

    UserPrivateMessenger.new(invitation).remind

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('Reminder')
    FakeYammer.message.should include(event_owner.name)
  end
end
