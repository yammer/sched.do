class ActivityCreator
  include Rails.application.routes.url_helpers

  def initialize(user, action, event)
    @action = action
    @user = user
    @event = event
  end

  def create
    post_activity_json
  rescue Exception => e
    Rails.logger.error(e.try(:response).try(:inspect))
    Rails.logger.error(generate_json)
    Rails.logger.error(@user.access_token)
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
          image: ActionController::Base.helpers.asset_path('logo.png')
        }
      },
      message: 'Fake message for testing purposes',
      users: @event.invitees_for_json
    }.to_json
  end

  def post_activity_json
    RestClient.post rest_client_url,
    generate_json,
    :content_type => :json,
    :accept => :json
  end

  def rest_client_url
    @user.yammer_endpoint +
      "api/v1/activity.json?access_token=#{@user.access_token}"
  end
end
