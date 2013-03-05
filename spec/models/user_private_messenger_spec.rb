require 'spec_helper'

describe UserPrivateMessenger, '#invitation' do
  it 'sends the correct invitation' do
    invitee = build_stubbed(:user)
    event = build_stubbed(:event)
    invitation_text = 'custom text'
    invitation = build(:invitation,
      event: event,
      invitee: invitee,
      invitation_text: invitation_text,
      sender: event.owner)

    UserPrivateMessenger.new(invitation).invite

    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include('vote')
    expect(FakeYammer.message).to include(invitation_text)
    expect(FakeYammer.message).to include(URL_HELPERS.event_url(event))
  end
end
