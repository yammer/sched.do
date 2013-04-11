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

    expect(Delayed::Job).to have_received(:enqueue).
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

    expect(yam_session_stub).to have_received(:post).
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
          image: event.watermarked_image.url
        }
      },
      message: '',
      users: invitees_for_json(event)
    }
  end

  def invitees_for_json(event)
    event.invitees.map { |i| { name: i.name, email: i.email } }
  end
end

describe ActivityCreatorJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = ActivityCreatorJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end

  it 'does not send exception to Airbrake if the job errors due to rate limit' do
    job = ActivityCreatorJob.new
    exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
    Airbrake.stubs(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).never
  end
end

describe ActivityCreatorJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = ActivityCreatorJob.new
    job_record = stub(last_error: 'boom')
    Airbrake.stubs(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).with('Job failure: boom')
  end
end
