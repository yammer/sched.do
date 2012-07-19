class PrivateMessage
 MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"
  def initialize(user, action, event)
    @action = action
    @user = user
    @event = event
  end

  def create
    response = RestClient.post MESSAGES_ENDPOINT, { 
      access_token: @user.access_token,
      message: @message
    }

  rescue Exception => e
    Rails.logger.debug(e.response.inspect)
    Rails.logger.debug(generate_json.inspect)
    raise
  end

end
