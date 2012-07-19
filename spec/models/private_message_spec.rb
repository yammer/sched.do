require 'spec_helper'

describe PrivateMessage do
  it 'posts to a Yammer Private Message when created' do
    event = build_stubbed_event
    build_private_message({ access_token: 'ABC123',
                             name: 'Fred Jones',
                             email: 'fred@example.com',
                             message: 'You have been invited to the event "Clown party"',
                          }).create

    FakeYammer.activity_endpoint_hits.should eq(1)

  end

  def build_private_message(args)
    user = build_stubbed(:user,
                         email: args[:email],
                         access_token: args[:access_token],
                         name: args[:name])
    message = args[:message]

    PrivateMessage.new(user, message, args[:event])
  end


  def build_stubbed_event
    event = build_stubbed(:event)
    event.generate_uuid
    invitees = [build_stubbed(:user), build_stubbed(:user)]
    event.stubs(:invitees).returns(invitees)
    event
  end
end
