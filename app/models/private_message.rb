class PrivateMessage
  Rails.application.routes.default_url_options = ActionMailer::Base.default_url_options
  MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"

  def initialize(event, recipient, message)
    @event = event
    @user = event.user
    @recipient = recipient
    @message = message
  end

  def create
    response = RestClient.post MESSAGES_ENDPOINT, {
      access_token: @user.access_token,
      message: @message,
      direct_to_id: @recipient.yammer_user_id,
      og_url: Rails.application.routes.url_helpers.event_url(@event)
    }
  #rescue Exception => e
  #  Rails.logger.debug(e.response.inspect)
  #  Rails.logger.debug(generate_json.inspect)
  #  raise
  end
end
