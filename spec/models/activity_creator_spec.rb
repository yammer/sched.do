require 'spec_helper'

describe ActivityCreator do
  it 'posts to the Yammer API on create' do
    event = build_stubbed_event

    build_activity_creator( {
      access_token: 'ABC123',
      name: 'Fred Jones',
      email: 'fred@example.com',
      action: 'vote',
      event: event
    } ).create

    RestClient.should have_received(:post).with(
      "https://www.yammer.com/api/v1/activity.json?access_token=ABC123",
      {
        activity: {
          actor: {
            name: 'Fred Jones',
            email: 'fred@example.com'
          },
          action: 'vote',
          object: {
            url: Rails.application.routes.url_helpers.event_url(event),
            type: 'poll',
            title: event.name,
            image: ActionController::Base.helpers.asset_path('logo.png')
          }
        },
        message: 'Fake message for testing purposes',
        users: event.invitees_for_json
      }.to_json,
      :content_type => :json,
      :accept => :json
    )
  end

  def build_activity_creator(args)
    RestClient.stubs(:post)

    user = build_stubbed(
      :user,
      email: args[:email],
      access_token: args[:access_token],
      name: args[:name]
    )

    action = args[:action]

    ActivityCreator.new(user, action, args[:event])
  end

  def build_stubbed_event
    event = build_stubbed(:event)
    event.generate_uuid
    invitees = [ build_stubbed(:user), build_stubbed(:user) ]
    event.stubs(:invitees).returns(invitees)
    event
  end
end
