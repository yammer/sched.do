class PrivateMessenger
  include Rails.application.routes.url_helpers

  def initialize(recipient, message, message_object)
    @message = message
    @recipient = recipient
    @message_object = message_object
    send(@message)
  end

  def reminder
    @invitation = @message_object
    @event = @invitation.event
    @sender = @invitation.event.user
    @message_body = reminder_message_body
  end

  def group_reminder
    @invitation = @message_object
    @event = @invitation.event
    @sender = @invitation.event.user
    @message_body = reminder_message_body
  end

  def invitation
    @invitation = @message_object
    @event = @invitation.event
    @sender = @invitation.event.user
    @message_body = invitation_message_body
  end

  def group_invitation
    @invitation = @message_object
    @event = @invitation.event
    @sender = @invitation.event.user
    @message_body = group_invitation_message_body
  end

  def deliver
    post_to_yammer({
      body: @message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    })
  end

  private

  def reminder_message_body
    <<-BODY.strip_heredoc
      Reminder: Help out #{@event.user.name} by voting on "#{@event.name}".

      Please click this link to view the options and vote: #{event_url(@event)}

      *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def invitation_message_body
     <<-BODY.strip_heredoc
      #{@recipient.name}, I am planning "#{@event.name}" and I need your help.

      Please click this link to view the options and vote: #{event_url(@event)}


      Thanks in advance!
      -#{@event.user.name}

      *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
    BODY
  end

  def group_invitation_message_body
      <<-BODY.strip_heredoc
       Attention #{@recipient.name}, I need your input on "#{@event.name}".

       Please click this link to vote: #{event_url(@event)}. Thanks!

       *This poll was sent using Sched.do. Create your own polls for free at #{root_url}
     BODY
  end

  def messages_endpoint
    @sender.yammer_endpoint + "api/v1/messages.json"
  end

  def post_to_yammer(message)
    RestClient.post messages_endpoint + "?" +
      message.merge(access_token: @sender.access_token).
      to_query, nil
  end

  def send_group_message
    post_to_yammer({
      body: group_message_body,
      group_id: @recipient.yammer_group_id,
      og_url: event_url(@event)
    })
  end
end
