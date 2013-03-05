class UserPrivateMessenger
  include Rails.application.routes.url_helpers
  include Invitability
  include Remindability

  def initialize(invitation, sender=invitation.sender)
    @recipient = invitation.invitee
    @sender = sender
    @event = invitation.event
    @invitation_template_path = '/users/invitation.erb'
    @invitation_text = invitation.invitation_text
  end

  private

  def deliver
    @sender.yammer_client.post(
      '/messages',
      body: @message_body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    )
  end
end
