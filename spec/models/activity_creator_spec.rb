require 'spec_helper'

describe ActivityCreator do
  it 'posts to the Yammer API on create' do
    RestClient.stubs(:post)
    user = build_stubbed(:user,
                         access_token: 'ABC123',
                         name: 'Fred Jones')
    event = build_stubbed(:event)
    action = 'create'
    invitees = [build_stubbed(:user), build_stubbed(:user)]
    event.stubs(:invitees).returns(invitees)

    ActivityCreator.new(user, action, event).create

    RestClient.should have_received(:post).with(
      "https://www.yammer.com/api/v1/activity.json?access_token=ABC123",
      {
        activity: {
          actor: { name: user.name, email: user.email },
          action: 'create',
          object: {
            url: "https://sched.do/events/#{event.id}",
            type: 'file',
            title: event.name,
            image: 'http://sched.do/logo.gif'
          }
        },
        message: 'Fake message for testing purposes',
        users: event.invitees_for_json
      }.to_json,
      :content_type => :json,
      :accept => :json
    )
  end
end
