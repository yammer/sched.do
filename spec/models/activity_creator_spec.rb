require 'spec_helper'

describe ActivityCreator do
  include DelayedJobSpecHelper

  it 'posts to the Yammer API on create' do
    RestClient.stubs(:post)
    user = build_stubbed_user
    action = 'vote'
    event = build_stubbed_event

    ActivityCreator.new(user, action, event).create
    work_off_delayed_jobs

    RestClient.should have_received(:post).with(
      "https://www.yammer.com/api/v1/activity.json?access_token=ABC123",
      expected_json(event),
      :content_type => :json,
      :accept => :json
    )
  end

  it 'should queue up a delayed job on #create' do
    user = build_stubbed_user
    action = 'vote'
    event = build_stubbed_event

    ActivityCreator.new(user, action, event).create

    Delayed::Job.count == 1

    work_off_delayed_jobs
  end

  private

  def build_stubbed_event
    event = build_stubbed(:event)
    event.generate_uuid
    invitees = [ build_stubbed(:user), build_stubbed(:user) ]
    event.stubs(:invitees).returns(invitees)
    event
  end

  def build_stubbed_user
    user = build_stubbed(
      :user,
      email: 'fred@example.com',
      access_token: 'ABC123',
      name: 'Fred Jones'
    )
  end

  def expected_json(event)
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
    }.to_json
  end
end
