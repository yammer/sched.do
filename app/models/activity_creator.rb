class ActivityCreator
  include Rails.application.routes.url_helpers

  def initialize(user, action, event)
    @user = user
    @action = action
    @event = event
  end

  def post
    post_activity_json
  end

  private

  def generate_json
    {
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
    }.to_json
  end

  def json_arguments
    { content_type: :json, accept: :json }
  end

  def post_activity_json
    RestClient.delay.post(rest_client_url, generate_json, json_arguments)
  end

  def rest_client_url
    @user.yammer_endpoint +
      "api/v1/activity.json?access_token=#{@user.access_token}"
  end
end
