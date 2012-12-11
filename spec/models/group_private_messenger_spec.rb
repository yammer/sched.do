require 'spec_helper'

describe GroupPrivateMessenger, '#invitation' do
  it 'sends a group invitation' do
    owner = build_stubbed(:user)
    group = build_stubbed(:group)
    event = build_stubbed(:event, owner: owner)
    invitation = build_stubbed(
      :invitation_with_group,
      event: event,
      invitee: group,
      sender: owner
    )

    GroupPrivateMessenger.new(invitation).invite

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include('I want your input')
    FakeYammer.message.should include(event.name)
    FakeYammer.message.should include(group.name)
    FakeYammer.message.should_not include(event.owner.name)
  end

  it 'should include the event owner name if the sender is not the event owner' do
    invitation = build_stubbed(:invitation)

    GroupPrivateMessenger.new(invitation).invite

    FakeYammer.message.should include(invitation.event.owner.name)
  end
end
