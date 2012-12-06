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
    FakeYammer.message.should include(event.name)
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

describe GroupPrivateMessenger, '#get_help_out_test' do
  it 'returns out <owner name> when the recipient is not the owner' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    help_out_text = GroupPrivateMessenger.new(invitation, sender).get_help_out_text

    help_out_text.should == "out #{invitation.event.owner.name}"
  end

  it 'return me out when the recipient is the owner' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)
    invitation.invitee = invitation.event.owner

    help_out_text =  GroupPrivateMessenger.new(invitation, sender).get_help_out_text

    help_out_text.should == 'me out'
  end
end
