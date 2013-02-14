require 'spec_helper'
require 'mail_helper'

describe MailHelper, '#get_first_line_of_invitation' do
  it 'returns the string without the event owner name repeated when the event owner is sender' do
    event = build_stubbed(:event)
    owner = event.owner
    invitation = build_stubbed(:invitation, sender: owner, event: event)
    poll_link = link_to(
      invitation.event.name,
      event_url(
        invitation.event,
        utm_campaign: 'sched.do',
        utm_medium: 'email',
        utm_source: 'event-invitation',
        guest_email: invitation.invitee.email
      ),
      html_options = { style: 'color: #EC6E4D' }
    )

    first_line = get_first_line_of_invitation(invitation)

    first_line.should == " created the #{poll_link} poll and wants input."
  end

  it 'returns the event creator and sender name when the sender is not the event owner' do
    invitation = build_stubbed(:invitation)
    sender_name = invitation.sender.name
    poll_link = link_to(
      invitation.event.name,
      event_url(
        invitation.event,
        utm_campaign: 'sched.do',
        utm_medium: 'email',
        utm_source: 'event-invitation',
        guest_email: invitation.invitee.email
      ),
      html_options = { style: 'color: #EC6E4D' }
    )

    first_line = get_first_line_of_invitation(invitation)

    first_line.should == " created the #{poll_link} poll and #{sender_name} wants input."
    end
end
