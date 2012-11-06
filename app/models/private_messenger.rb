class PrivateMessenger
  include Rails.application.routes.url_helpers

  def initialize(recipient, message, sender, message_object)
    @recipient = recipient
    @message = message
    @sender = sender
    @message_object = message_object
    send(@message)
  end

  def reminder
    @invitation = @message_object
    @event = @invitation.event
    @message_body = reminder_message_body
  end

  def group_reminder
    @invitation = @message_object
    @event = @invitation.event
    @message_body = reminder_message_body
  end

  def invitation
    @invitation = @message_object
    @event = @invitation.event
    @message_body = invitation_message_body
  end

  def group_invitation
    @invitation = @message_object
    @event = @invitation.event
    @message_body = group_invitation_message_body
  end

  def deliver
    if @recipient.yammer_user_id
      send_user_message
    else
      send_group_message
    end
  end

  private

  def reminder_message_body
    <<-BODY.strip_heredoc
      Reminder: Help out #{@event.owner} by voting on "#{@event.name}".

      Please click this link to view the options and vote: #{event_url(@event)}

      *This poll was sent using sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def invitation_message_body
    <<-BODY.strip_heredoc
      #{@event.owner} created the "#{@event.name}" poll and I want your input.

       Please click this link to view the options and vote: #{event_url(@event)}

       *This poll was sent using sched.do. Create your own polls for free at #{root_url}
     BODY
  end

  def group_invitation_message_body
    <<-BODY.strip_heredoc
      Attention #{@recipient.name}: #{@event.owner} created the "#{@event.name}" poll and I want your input.

      Please click this link to view the options and vote: #{event_url(@event)}
      *This poll was sent using sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def messages_endpoint
    @sender.yammer_endpoint + '/api/v1/messages.json'
  end

  def post_to_yammer(message)
    RestClient.post messages_endpoint + "?" +
      message.merge(access_token: @sender.access_token).
      to_query, nil
  end

  def send_group_message
    post_to_yammer({
      body: @message_body,
      group_id: @recipient.yammer_group_id,
      og_url: event_url(@event)
    })
  end

  def send_user_message
    post_to_yammer({
      body: @message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    })
  end
end
