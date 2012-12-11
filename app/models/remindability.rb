module Remindability
  def remind
    @help_out = get_help_out_text
    @message_body = PrivateMessageTemplate.new('/shared/reminder.erb', binding).body
    deliver
  end

  def get_help_out_text
    if @recipient == @event.owner
      'me out'
    else
      "out #{@event.owner.name}"
    end
  end
end
