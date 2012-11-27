class UserPrivateMessenger
  include Rails.application.routes.url_helpers

  def initialize(invitation, sender=invitation.sender)
    @recipient = invitation.invitee
    @sender = sender
    @event = invitation.event
  end

  def invite
    @message_body = PrivateMessage.new('/users/invitation.erb', binding).body
    deliver
  end

  def remind
    @message_body = PrivateMessage.new('/shared/reminder.erb', binding).body
    deliver
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
