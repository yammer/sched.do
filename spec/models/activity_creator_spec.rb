require 'spec_helper'

describe ActivityCreator, '#post' do
  include DelayedJobSpecHelper

  it 'posts to the Yammer API on post' do
    RestClient.stubs(:post)
    user = build_user
    action = 'vote'
    event = build_stubbed(:event_with_invitees)

    ActivityCreator.new(user, action, event).post
    work_off_delayed_jobs

    RestClient.should have_received(:post).with(
      'https://www.yammer.com/api/v1/activity.json?access_token=ABC123',
      expected_json(event),
      content_type: :json,
      accept: :json
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

  it 'expires the access_token if it is stale' do
    Delayed::Worker.delay_jobs = false
    user = build_user('OLDTOKEN')
    action = 'vote'
    event = build_stubbed(:event_with_invitees)

    ActivityCreator.new(user, action, event).post

    user.access_token.should == 'EXPIRED'
    Delayed::Worker.delay_jobs = true
  end

  private

  def build_user(token = 'ABC123')
    user = create(
      :user,
      email: 'fred@example.com',
      access_token: token,
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
