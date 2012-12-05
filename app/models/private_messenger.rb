module PrivateMessenger
  def remind
    @help_out = get_help_out_text
    @message_body = PrivateMessage.new('/shared/reminder.erb', binding).body
    deliver
  end

  def get_help_out_text
    if @recipient == @event.owner
      return 'me out'
    else
      return "out #{@event.owner.name}"
    end
  end
end
