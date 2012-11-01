require 'spec_helper'

describe ActivityCreator, '#post' do
  include DelayedJobSpecHelper

  it 'posts to the Yammer API on post' do
    RestClient.stubs(:post)
    action = 'vote'
    event = build_stubbed(:event_with_invitees)
    user = build_stubbed_user

    ActivityCreator.new(user, action, event).post
    work_off_delayed_jobs

    RestClient.should have_received(:post).with(
      "https://www.yammer.com/api/v1/activity.json?access_token=ABC123",
      expected_json(event),
      :content_type => :json,
      :accept => :json
    )
  end

  it 'creates a delayed job' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)

    expect {
      ActivityCreator.new(user, action, event).post
    }.to change(Delayed::Job, :count).by(1)
  end

  private

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
          image: 'http://' + ENV['HOSTNAME'] + '/logo.png'
        }
      },
      message: '',
      users: event.invitees_for_json
    }.to_json
  end
end
