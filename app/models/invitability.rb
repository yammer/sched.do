module Invitability
  def invite
    @message_body = PrivateMessageTemplate.
      new(@invitation_template_path, binding).
      body
    deliver
  end
end
