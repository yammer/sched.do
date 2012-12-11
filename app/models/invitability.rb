module Invitability
  def invite
    @event_creator = get_event_creator_text
    @message_body = PrivateMessageTemplate.new(@invitation_template_path, binding).body
    deliver
  end

  def get_event_creator_text
    if @sender == @event.owner
      'I'
    else
      @event.owner.name
    end
  end
end
