class GroupPrivateMessenger
  include Rails.application.routes.url_helpers
  include Invitability
  include Remindability

  def initialize(invitation, sender=invitation.sender)
    @recipient = invitation.invitee
    @sender = sender
    @event = invitation.event
    @invitation_template_path = '/groups/invitation.erb'
  end

  private

  def deliver
    @sender.yammer_client.post(
      '/messages',
      body: @message_body,
      group_id: @recipient.yammer_group_id,
      og_url: event_url(@event)
    )
  end
end
