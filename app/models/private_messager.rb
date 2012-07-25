class PrivateMessager < AbstractController::Base
  include Rails.application.routes.url_helpers
  MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"

  def initialize(invitation)
    @template = 'invitation'
    @recipient = invitation.invitee
    @event = invitation.event
    @user = @event.user
  end

  def deliver
    response = RestClient.post MESSAGES_ENDPOINT + "?" + {
      access_token: @user.access_token,
      body: message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    }.to_query, nil
  end

  private

  def message_body
     <<-BODY.strip_heredoc
      #{@recipient.name}, I am planning "#{@event.name}" and I need your help.

      Please click this link to view the options and vote: #{event_url(@event)}


      Thanks in advance!
      -#{@event.user.name}

      *This poll was sent using Sche.do. Create your own polls for free at #{root_url}
    BODY
  end
end
