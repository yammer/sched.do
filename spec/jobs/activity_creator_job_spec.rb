require 'spec_helper'

describe ActivityCreatorJob, '.enqueue' do
  it 'enqueues the job' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)

    ActivityCreatorJob.enqueue(user, action, event)

    should enqueue_delayed_job('ActivityCreatorJob').
      with_attributes(user_id: user.id, action: action, event_id: event.id).
      priority(1)
  end
end

describe ActivityCreatorJob, '#perform' do
  include DelayedJobSpecHelper

  it 'configures Yammer' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)
    User.stubs(find: user)
    Event.stubs(find: event)

    ActivityCreatorJob.new(user, action, event).perform

    Yam.oauth_token.should == user.access_token
  end

  it 'posts to the Yammer activity endpoint' do
    user = build_user
    action = 'vote'
    event = build_stubbed(:event)
    User.stubs(find: user)
    Event.stubs(find: event)
    Yam.stubs(:post)

    ActivityCreatorJob.new(user, action, event).perform

    Yam.should have_received(:post).with('/activity', expected_json(event))
  end

  it 'expires the access_token if it is stale' do
    user = build_user('OLDTOKEN')
    action = 'vote'
    event = build_stubbed(:event)
    Yam.oauth_token = user.access_token
    Event.stubs(find: event)
    User.stubs(find: user)

    ActivityCreatorJob.new(user, action, event).perform

    user.access_token.should == 'EXPIRED'
    Yam.set_defaults
  end

  it 'logs an error if the access token is stale' do
    fake_logger = stub(error: 'error message')
    Rails.stubs(logger: fake_logger)
    user = build_user('OLDTOKEN')
    action = 'vote'
    event = build_stubbed(:event)
    Yam.oauth_token = user.access_token
    Event.stubs(find: event)
    User.stubs(find: user)

    ActivityCreatorJob.new(user, action, event).perform

    fake_logger.should have_received(:error)
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
    }
  end
end

describe ActivityCreatorJob, '.error' do
  it 'sends Airbrake an exception if the job fails' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)
    Airbrake.stubs(:notify)
    exception = 'Hey! You did something wrong!'

    job = ActivityCreatorJob.new(user, action, event)
    job.error(job, exception)

    Airbrake.should have_received(:notify).with(exception)
  end
end
