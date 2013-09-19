class YammerMessenger
  include Rails.application.routes.url_helpers

  def initialize(recipient)
    @recipient = recipient
  end

  def invite(invitation)
    @sender = invitation.sender
    @event = invitation.event
    @custom_text = invitation.invitation_text
    @utm_source = utm_source(__method__)

    deliver
  end

  def remind(event, sender)
    @sender = sender
    @event = event
    @custom_text = reminder_text
    @utm_source = utm_source(__method__)

    deliver
  end

  def notify(event, message)
    @sender = event.owner
    @event = event
    @custom_text = message
    @utm_source = utm_source(__method__)

    deliver
  end

  private

  def deliver
    @sender.yammer_client.create_message(message_body, request_params)
  end

  def request_params
    @request_params ||= {
      body: message_body,
      og_url: event_url(@event),
      direct_to_id: @recipient.yammer_user_id
    }
  end

  def utm_source(invoking_method)
    case invoking_method
    when :invite
      'event-invitation'
    when :remind
      'event-reminder'
    when :notify
      'event-winner-notification'
    end
  end

  def message_body
    PrivateMessageTemplate.new('notification.erb', binding).body
  end

  def reminder_text
    "Reminder: Help #{help_out_text} by voting on #{@event.name}"
  end

  def help_out_text
    if @sender == @event.owner
      'me out'
    else
      "out #{@event.owner.name}"
    end
  end
end
