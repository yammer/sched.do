module MailHelper
  def get_first_line_of_invitation(invitation)
    @invitation = invitation

    if invitation.event.owner == invitation.sender
       " created the #{poll_link} poll and wants input.".html_safe
     else
       " created the #{poll_link} poll and #{sender_name} wants input.".html_safe
     end
  end

  private

  def poll_link
    link_to(
      @invitation.event.name,
      event_url(
        @invitation.event,
        utm_source: 'event-invitation',
        utm_medium: 'email',
        utm_campaign: 'sched.do',
        guest_email: @invitation.invitee.email
      ),
      html_options = { style: 'color: #EC6E4D' }
    )
  end

  def sender_name
    @invitation.sender.name
  end
end
