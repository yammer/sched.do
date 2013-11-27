require 'spec_helper'

describe ActivityCreatorJob, '.enqueue' do
  it 'enqueues the job' do
    user = build_stubbed(:user)
    action = 'vote'
    event = build_stubbed(:event)
    Delayed::Job.stub(:enqueue)
    activity_creator_job = ActivityCreatorJob.new(user.id, action, event.id)

    ActivityCreatorJob.enqueue(user, action, event)

    expect(Delayed::Job).to have_received(:enqueue).with(activity_creator_job)
  end
end

describe ActivityCreatorJob, '#perform' do
  include DelayedJobSpecHelper

  it 'posts to the Yammer activity endpoint' do
    user = build_user
    action = 'vote'
    event = build_stubbed(:event)
    User.stub(find: user)
    Event.stub(find: event)
    yam_session_stub = double(post: nil)
    Yam.stub(new: yam_session_stub)

    ActivityCreatorJob.new(user, action, event).perform

    expect(yam_session_stub).to have_received(:post).
      with('/activity', expected_json(event))
  end

  private

  def build_user(token = 'ABC123')
    create(:user,
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
    event.invitees.map { |invitee| { name: invitee.name, email: invitee.email } }
  end
end

describe ActivityCreatorJob, '#error' do
  it 'sends Airbrake an exception if the job errors' do
    job = ActivityCreatorJob.new
    exception = 'Hey! you did something wrong!'
    Airbrake.stub(:notify)

    job.error(job, exception)

    expect(Airbrake).to have_received(:notify).with(exception)
  end

  it 'does not send exception to Airbrake if the job errors due to rate limit' do
    job = ActivityCreatorJob.new
    exception = Faraday::Error::ClientError.new('Rate limited!', status: 429)
    Airbrake.stub(:notify)

    job.error(job, exception)

    expect(Airbrake).not_to have_received(:notify)
  end
end

describe ActivityCreatorJob, '#failure' do
  it 'sends Airbrake an exception if the job fails' do
    job = ActivityCreatorJob.new
    job_record = double(last_error: 'boom')
    Airbrake.stub(:notify)

    job.failure(job_record)

    expect(Airbrake).to have_received(:notify).
      with(error_message: 'Job failure: boom')
  end
end
