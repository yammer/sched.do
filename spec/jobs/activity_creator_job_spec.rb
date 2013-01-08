require 'spec_helper'

describe ActivityCreatorJob, '.enqueue' do
  it 'enqueues the job' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)
    Delayed::Job.stubs(:enqueue)
    activity_creator_job = ActivityCreatorJob.new(user.id, action, event.id)
    priority = 1

    ActivityCreatorJob.enqueue(user, action, event)

    Delayed::Job.should have_received(:enqueue).
      with(activity_creator_job, priority: priority)
  end
end

describe ActivityCreatorJob, '#perform' do
  include DelayedJobSpecHelper

  it 'posts to the Yammer activity endpoint' do
    user = build_user
    action = 'vote'
    event = build_stubbed(:event)
    User.stubs(find: user)
    Event.stubs(find: event)
    yam_session_stub = mock('yam session', :post)
    Yam.stubs(:new).returns(yam_session_stub)

    ActivityCreatorJob.new(user, action, event).perform

    yam_session_stub.should have_received(:post).
      with('/activity', expected_json(event))
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
