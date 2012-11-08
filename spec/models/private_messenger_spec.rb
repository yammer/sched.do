require 'spec_helper'

describe PrivateMessenger, '#invitation' do
  it 'sends the correct invitation' do
    event_owner = create(:user)
    invitee = create(:user)
    message = :invitation
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: invitee)

    PrivateMessenger.new(invitee, message, event_owner, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('vote')
    FakeYammer.message.should include(event_owner.name)
  end
end

describe PrivateMessenger, '#reminder' do
  it 'sends the correct reminder' do
    event_owner = create(:user)
    invitee = create(:user)
    message = :reminder
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: invitee)

    PrivateMessenger.new(invitee, message, event_owner, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('Reminder')
    FakeYammer.message.should include(event_owner.name)
  end
end

describe PrivateMessenger, '#group_invitation' do
  it 'sends a group invitation' do
    event_owner = create(:user)
    group = create(:group)
    message = :group_invitation
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: group)

    PrivateMessenger.new(group, message, event_owner, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('I want your input')
    FakeYammer.message.should include(group.name)
  end
end

describe PrivateMessenger, '#group_reminder' do
  it 'sends a group reminder' do
    event_owner = create(:user)
    group = create(:group)
    message = :group_reminder
    event = create(:event, owner: event_owner)
    invitation = build(:invitation, event: event, invitee: group)

    PrivateMessenger.new(group, message, event_owner, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('Reminder')
    FakeYammer.message.should include(event_owner.name)
  end
end
