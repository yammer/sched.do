require 'spec_helper'

describe PrivateMessage do
  it 'posts to a Yammer Private Message when created' do
    event = build_stubbed(:event)
    recipient = build_stubbed(:user)
    message = 'You are invited to the "Clown party"'

    private_message = PrivateMessage.new(event, recipient, message).create

    FakeYammer.messages_endpoint_hits.should == 1
  end
end
