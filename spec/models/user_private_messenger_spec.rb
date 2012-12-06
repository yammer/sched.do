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
    FakeYammer.message.should include(event.name)
  end
end

describe UserPrivateMessenger, '#get_help_out_test' do
  it 'returns out <owner name> when the recipient is not the owner' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    help_out_text = UserPrivateMessenger.new(invitation, sender).get_help_out_text

    help_out_text.should == "out #{invitation.event.owner.name}"
  end

  it 'return me out when the recipient is the owner' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)
    invitation.invitee = invitation.event.owner

    help_out_text =  UserPrivateMessenger.new(invitation, sender).get_help_out_text

    help_out_text.should == 'me out'
  end
end
