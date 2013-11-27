require 'spec_helper'

describe EventInviter, '#valid?' do
  it 'returns true if all invitations are valid' do
    current_user = build_stubbed(:user)
    event = build_stubbed(:event)
    invitation_text = 'Example text'
    invitee_emails = ['example1@example.com', 'example2@example.com']
    options = {
      current_user: current_user,
      event: event,
      invitation_text: invitation_text,
      invitee_emails: invitee_emails
    }

    valid = EventInviter.new(options).valid?

    expect(valid).to be true
  end

  it 'returns false if all invitations are not valid' do
    current_user = build_stubbed(:user)
    event = build_stubbed(:event)
    invitee_emails = ['example1@example.com', 'example@example.com']
    options = {
      current_user: current_user,
      event: event,
      invitee_emails: invitee_emails
    }

    valid = EventInviter.new(options).valid?

    expect(valid).to be false
  end
end

describe EventInviter, '#send_invitations' do
  it 'calls invite on each invitation' do
    invitation = double(invite: nil)
    Invitation.stub(new: invitation)
    current_user = build_stubbed(:user)
    event = build_stubbed(:event)
    invitation_text = 'Example text'
    invitee_emails = ['example1@example.com', 'example2@example.com']
    options = {
      current_user: current_user,
      event: event,
      invitation_text: invitation_text,
      invitee_emails: invitee_emails
    }

    EventInviter.new(options).send_invitations

    expect(Invitation).to have_received(:new).twice
    expect(invitation).to have_received(:invite).twice
  end
end

describe EventInviter, '#invalid_invitation_errors' do
  it 'returns the errors belonging to the first invalid invitation' do
    current_user = build_stubbed(:user)
    event = build_stubbed(:event)
    invitee_emails = ['example1@example.com', 'example2@example.com']
    options = {
      current_user: current_user,
      event: event,
      invitee_emails: invitee_emails
    }

    errors = EventInviter.new(options).invalid_invitation_errors

    expect(errors).to eq "Invitation text can't be blank"
  end
end
