require 'spec_helper'

describe InviteeBuilder, '#find_user_by_email_or_create_guest' do
  it 'searches for a user by email' do
    invitation = create(:invitation)
    user = build_stubbed(:user)
    User.stubs(:find_by_email)

    InviteeBuilder.new(user.email, invitation.event).
      find_user_by_email_or_create_guest

    expect(User).to have_received(:find_by_email).with(user.email)
    expect(Guest).to have_received(:find_by_email).with(user.email).never
  end

  it 'searches for a Guest by email if no User exists' do
    invitation = create(:invitation)
    guest = build_stubbed(:guest)
    Guest.stubs(:find_by_email)

    InviteeBuilder.new(guest.email, invitation.event).
      find_user_by_email_or_create_guest

    expect(Guest).to have_received(:find_by_email).with(guest.email)
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

      expect(yam_client_stub).to have_received(:get)
    end

    it 'creates a User if it finds an existing Yammer user' do
      invitation = create(:invitation)
      invitee_email = 'ralph@example.com'
      user = mock(:save!)
      translator = mock(translate: user)
      YammerUserResponseTranslator.stubs(new: translator)

      InviteeBuilder.new(invitee_email, invitation.event).
        find_user_by_email_or_create_guest

      expect(user).to have_received(:save!)
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

      expect(Guest).to have_received(:create).with(params)
    end
  end
end
