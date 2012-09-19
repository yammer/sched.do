require 'spec_helper'

describe PrivateMessenger, "#reminder" do
  it 'sends a reminder' do
    user = create(:user)
    invitee = create(:user)
    message = :reminder
    event = create(:event, owner: user)
    invitation = build(:invitation, event: event, invitee: invitee)

    PrivateMessenger.new(user, message, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include("Reminder")
    FakeYammer.message.should include(user.name)
  end
end

describe PrivateMessenger, "#group_reminder" do
  it 'sends a group reminder' do
    user = create(:user)
    group = create(:group)
    message = :group_reminder
    event = create(:event, owner: user)
    invitation = build(:invitation, event: event, invitee: group)

    PrivateMessenger.new(user, message, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include("Reminder")
    FakeYammer.message.should include(event.owner.name)
  end
end

describe PrivateMessenger, "#group_invitation" do
  it 'sends a group inviation' do
    user = create(:user)
    group = create(:group)
    message = :group_invitation
    event = create(:event, owner: user)
    invitation = build(:invitation, event: event, invitee: group)

    PrivateMessenger.new(group, message, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include("I need your input")
    FakeYammer.message.should include(group.name)
  end
end

describe PrivateMessenger, "#invitation" do
  it 'sends a invitation' do
    user = create(:user)
    message = :invitation
    event = create(:event, owner: user)
    invitation = build(:invitation, event: event)

    PrivateMessenger.new(user, message, invitation).deliver

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include("vote")
    FakeYammer.message.should include(user.name)
  end
end
