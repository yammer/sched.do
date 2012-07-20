class PrivateMessage
  include Rails.application.routes.url_helpers
  MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"

  def initialize(event, recipient, message)
    @event = event
    @user = event.user
    @recipient = recipient
    @message = message
    #self.default_url_options = ActionMailer::Base.default_url_options
  end

  def create

    uri = Addressable::URI.new
    uri.query_values = {
      access_token: @user.access_token,
      body: @message,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    }

    response = RestClient.post MESSAGES_ENDPOINT + "?" + uri.query.to_s, nil
  end
end
