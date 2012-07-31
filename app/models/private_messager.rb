class PrivateMessager
  include Rails.application.routes.url_helpers
  MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"

  def initialize(invitation)
    @template = 'invitation'
    @recipient = invitation.invitee
    @event = invitation.event
    @user = @event.user
  end

  def deliver
    response = RestClient.post messages_endpoint + "?" + {
      access_token: @user.access_token,
      body: message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    }.to_query, nil
  # rescue Exception => e
  #   Rails.logger.error(e.response.inspect)
  #   Rails.logger.error(@recipient.yammer_user_id)
  #   Rails.logger.error(@user.access_token)
  #   Rails.logger.error(event_url(@event))
  #   Rails.logger.error(message_body.inspect)
  #   raise
  end

  private

  def message_body
     <<-BODY.strip_heredoc
      #{@recipient.name}, I am planning "#{@event.name}" and I need your help.

      Please click this link to view the options and vote: #{event_url(@event)}


      Thanks in advance!
      -#{@event.user.name}

      *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def messages_endpoint
    @user.yammer_endpoint + "api/v1/messages.json"
  end
end
