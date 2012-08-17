class PrivateMessager
  include Rails.application.routes.url_helpers

  def initialize(invitation)
    @recipient = invitation.invitee
    @event = invitation.event
    @event_owner = @event.user
  end

  def deliver
    if @recipient.yammer_group_id.present?
      send_group_message
    else
      send_user_message
    end
  end

  private

  def group_message_body
     <<-BODY.strip_heredoc
      Attention #{@recipient.name}, I need your input on "#{@event.name}".

      Please click this link to vote: #{event_url(@event)}. Thanks!

      *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def messages_endpoint
    @event_owner.yammer_endpoint + "api/v1/messages.json"
  end

  def post_to_yammer(message)
    RestClient.delay.post messages_endpoint + "?" +
      message.merge(access_token: @event_owner.access_token).
      to_query, nil
  end

  def send_user_message
    post_to_yammer({
      body: user_message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    })
  end

  def send_group_message
    post_to_yammer({
      body: group_message_body,
      group_id: @recipient.yammer_group_id,
      og_url: event_url(@event)
    })
  end

  def user_message_body
     <<-BODY.strip_heredoc
      #{@recipient.name}, I am planning "#{@event.name}" and I need your help.

      Please click this link to view the options and vote: #{event_url(@event)}


      Thanks in advance!
      -#{@event.user.name}

      *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
    BODY
  end
end
