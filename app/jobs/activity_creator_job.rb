class ActivityCreatorJob < Struct.new(:user_id, :action, :event_id)
  include Rails.application.routes.url_helpers
  include YammerRateLimited

  def self.enqueue(user, action, event)
    job = new(user.id, action, event.id)

    Delayed::Job.enqueue(job)
  end

  def perform
    post_yammer_activity
  end

  private

  def user
    @user ||= User.find(user_id)
  end

  def post_yammer_activity
    user.yammer_client.create_activity(json_payload)
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
          image: event.watermarked_image.url
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
    event.invitees.map do |invitee|
      { name: invitee.name, email: invitee.email }
    end
  end
end
