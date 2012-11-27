require 'spec_helper'

describe GroupPrivateMessenger, '#invitation' do
  it 'sends a group invitation' do
    group = build_stubbed(:group)
    event = create(:event)
    invitation = build(
      :invitation_with_group,
      event: event,
      invitee: group
    )

    GroupPrivateMessenger.new(invitation).invite

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('I want your input')
    FakeYammer.message.should include(group.name)
  end
end

describe GroupPrivateMessenger, '#reminder' do
  it 'sends a group reminder' do
    event_owner = create(:user)
    group = build_stubbed(:group)
    event = create(:event, owner: event_owner)
    invitation = build(:invitation_with_group, event: event, invitee: group)

    GroupPrivateMessenger.new(invitation).remind

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('Reminder')
    FakeYammer.message.should include(event_owner.name)
  end
end
