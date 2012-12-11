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

    remindability.message_body.should include('Reminder')
    remindability.message_body.should include(event.owner.name)
  end

  it 'calls deliver' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    remindability.should have_received(:deliver)
  end

  it 'calls event_url' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    remindability.should have_received(:event_url)
  end

  it 'calls root_url' do
    sender = build_stubbed(:user)
    recipient = build_stubbed(:user)
    event = build_stubbed(:event, owner: sender)
    remindability = build_remindability(sender, recipient, event)

    remindability.remind

    remindability.should have_received(:root_url)
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
  context 'recipient is not the owner' do
      it "returns 'out owner name'" do
      event = build_stubbed(:event)
      recipient = build_stubbed(:user)
      remindability = TestRemindability.new(recipient, nil, event)

      help_out_text = remindability.get_help_out_text

      help_out_text.should == "out #{event.owner.name}"
    end
  end

  context 'recipient is the owner' do
    it "return 'me out'" do
      event = build_stubbed(:event)
      recipient = event.owner
      remindability = TestRemindability.new(recipient, nil, event)

      help_out_text =  remindability.get_help_out_text

      help_out_text.should == 'me out'
    end
  end
end
