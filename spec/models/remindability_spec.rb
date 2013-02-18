require 'spec_helper'

class TestRemindability
  include Remindability
  attr_reader :message_body

  def initialize(recipient, sender, event)
    @recipient = recipient
    @sender = sender
    @event = event
  end
end

describe Remindability, '#remind' do
  it 'sends a group reminder' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    expect(remindability.message_body).to include('Reminder')
    expect(remindability.message_body).to_not include(event.owner.name)
  end

  it 'calls deliver' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    expect(remindability).to have_received(:deliver)
  end

  it 'calls event_url' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    expect(remindability).to have_received(:event_url)
  end

  it 'calls root_url' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    expect(remindability).to have_received(:root_url)
  end

  def build_remindability(sender, recipient, event)
    remindability = TestRemindability.new(recipient, sender, event)
    remindability.stubs(:deliver)
    remindability.stubs(:event_url)
    remindability.stubs(:root_url)
    remindability
  end
end

describe Remindability, '#get_help_out_text' do
  context 'sender is not the owner' do
    it "returns 'out owner name'" do
      event = build_stubbed(:event)
      sender = build_stubbed(:user)
      remindability = TestRemindability.new(nil, sender, event)

      help_out_text = remindability.get_help_out_text

      expect(help_out_text).to eq "out #{event.owner.name}"
    end
  end

  context 'sender is the owner' do
    it "return 'me out'" do
      event = build_stubbed(:event)
      sender = event.owner
      remindability = TestRemindability.new(nil, sender, event)

      help_out_text =  remindability.get_help_out_text

      expect(help_out_text).to eq 'me out'
    end
  end
end
