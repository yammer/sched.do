require 'spec_helper'

class TestInvitability
  include Invitability
  attr_reader :message_body

  def initialize(sender, event)
    @sender = sender
    @event = event
  end
end

describe Invitability, '#get_event_creator_text' do
  it "return 'I' when the recipient is the owner" do
    event = build_stubbed(:event)
    sender = event.owner
    invitability = TestInvitability.new(sender, event)

    event_creator_text = invitability.get_event_creator_text

    expect(event_creator_text).to eq 'I'
  end

  it 'return owner name when the sender is not the owner' do
    event = build_stubbed(:event)
    sender = build_stubbed(:user)
    invitability = TestInvitability.new(sender, event)

    event_creator_text = invitability.get_event_creator_text

    expect(event_creator_text).to eq event.owner.name
  end
end
