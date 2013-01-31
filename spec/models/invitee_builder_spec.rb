require 'spec_helper'

describe InviteeBuilder, '#find_user_by_email_or_create_guest' do
  it 'searches for a user by email' do
    invitation = create(:invitation)
    user = build_stubbed(:user)
    User.stubs(:find_by_email)

    InviteeBuilder.new(user.email, invitation.event).
      find_user_by_email_or_create_guest

    User.should have_received(:find_by_email).with(user.email)
    Guest.should have_received(:find_by_email).with(user.email).never
  end

  it 'searches for a Guest by email if no User exists' do
    invitation = create(:invitation)
    guest = build_stubbed(:guest)
    Guest.stubs(:find_by_email)

    InviteeBuilder.new(guest.email, invitation.event).
      find_user_by_email_or_create_guest

    Guest.should have_received(:find_by_email).with(guest.email)
  end

  context 'if no User or Guest is found' do
    it 'searches for existing Yammer users' do
      invitation = create(:invitation)
      access_token = invitation.sender.access_token
      invitee_email = 'ralph@example.com'
      yam_client_stub = mock('yam session', :get)
      Yam.stubs(:new).returns(yam_client_stub)

      InviteeBuilder.new(invitee_email, invitation.event).
        find_user_by_email_or_create_guest

      yam_client_stub.should have_received(:get)
    end

    it 'creates a User if it finds an existing Yammer user' do
      invitation = create(:invitation)
      event_owner = invitation.event.owner
      access_token = event_owner.access_token
      yammer_staging = false
      invitee_email = 'ralph@example.com'
      invitee_user_id = 1488374236
      yammer_user = stub('yammer_user', :find_or_create)
      YammerUser.stubs(new: yammer_user)

      InviteeBuilder.new(invitee_email, invitation.event).
        find_user_by_email_or_create_guest

      YammerUser.should have_received(:new).with(
        access_token: access_token,
        yammer_staging: yammer_staging,
        yammer_user_id: invitee_user_id
      )
    end
  end

  context 'if no Yammer Users are found' do
    it 'creates a guest with only an email address' do
      invitation = create(:invitation)
      event = invitation.event
      email = 'george@example.com'
      params = { email: email }
      Guest.stubs(:create)

      InviteeBuilder.new(email, event).find_user_by_email_or_create_guest

      Guest.should have_received(:create).with(params)
    end
  end
end
