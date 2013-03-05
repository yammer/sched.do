require 'spec_helper'

describe GroupPrivateMessenger, '#invitation' do
  it 'sends a group invitation' do
    group = build_stubbed(:group)
    event = build_stubbed(:event)
    invitation_text = 'custom text'

    invitation = build_stubbed(
      :invitation_with_group,
      event: event,
      invitation_text: invitation_text,
      invitee: group,
      sender: event.owner
    )

    GroupPrivateMessenger.new(invitation).invite

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include('vote')
    expect(FakeYammer.message).to include(invitation_text)
    expect(FakeYammer.message).to include(URL_HELPERS.event_url(event))
  end
end
