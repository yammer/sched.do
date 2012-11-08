class ActivityCreator
  include Rails.application.routes.url_helpers

  def initialize(user, action, event)
    @user = user
    @action = action
    @event = event
  end

  def post
    Yam.delay.post(
      "/activity",
      activity: {
        actor: {
          name: @user.name,
          email: @user.email
        },
        action: @action,
        object: {
          url: event_url(@event),
          type: 'poll',
          title: @event.name,
          image: 'http://' + ENV['HOSTNAME'] + '/logo.png'
        }
      },
      message: '',
      users: @event.invitees_for_json
    )
  rescue Faraday::Error::ClientError
    @user.expire_token
  end
end
