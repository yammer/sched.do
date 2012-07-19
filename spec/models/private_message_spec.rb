require 'spec_helper'

describe PrivateMessage do
 it 'posts to a Yammer Private Message when inviting users' do
    event = build_stubbed_event

    RestClient.should have_received(:post)
  end

  #helper methods

  def build_stubbed_event
    event = build_stubbed(:event)
    event.generate_uuid
    invitees = [build_stubbed(:user), build_stubbed(:user)]
    event.stubs(:invitees).returns(invitees)
    event
  end
end
