class EventCloser
  def initialize(event, options = {})
    @event = event
    @winning_suggestion_type = options[:winning_suggestion_type]
    @winning_suggestion_id = options[:winning_suggestion_id]
    @message = options[:message]
  end

  def process
    if @event.open?
      @event.update_attributes(
        winning_suggestion_id: @winning_suggestion_id,
        winning_suggestion_type: @winning_suggestion_type,
        open: false
      )

      send_notifications
    end
  end

  private

  def send_notifications
    participants = @event.invitees + @event.groups

    participants.each do |invitee|
      invitee.delay.notify(@event, @message)
    end

    UserMailer.delay.closed_event_notification(@event)
  end
end
