# Delayed job for posting activity stories to the Yammer API endpoint

class ActivityCreatorJob < Struct.new(:user_id, :action, :event_id)
  include Rails.application.routes.url_helpers

  PRIORITY = 1

  def self.enqueue(user, action, event)
    Delayed::Job.enqueue(
      new(user.id, action, event.id),
      priority: PRIORITY
    )
  end

  def perform
    post_yammer_activity
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def user
    @user ||= User.find(user_id)
  end

  def post_yammer_activity
    user.yammer_client.post('/activity', json_payload)
  end

  def json_payload
    {
      activity: {
        actor: {
          name: user.name,
          email: user.email
        },
        action: action,
        object: {
          url: event_url(event),
          type: 'poll',
          title: event.name,
          image: 'http://' + ENV['HOSTNAME'] + '/logo.png'
        }
      },
      message: '',
      users: invitees_for_json
    }
  end

  def event
    @event ||= Event.find(event_id)
  end

  def invitees_for_json
    event.invitees.map { |i| { name: i.name, email: i.email } }
  end
end
