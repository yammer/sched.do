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

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include('I want your input')
    expect(FakeYammer.message).to include(event.name)
    expect(FakeYammer.message).to include(group.name)
    expect(FakeYammer.message).to_not include(event.owner.name)
  end

  it 'should include the event owner name if the sender is not the event owner' do
    invitation = build_stubbed(:invitation)

    GroupPrivateMessenger.new(invitation).invite

    expect(FakeYammer.message).to include(invitation.event.owner.name)
  end
end
