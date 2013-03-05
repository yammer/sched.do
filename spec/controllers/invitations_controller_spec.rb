require 'spec_helper'

describe InvitationsController, 'authentication' do
  it 'requires guest or yammer login for #create' do
    post :create

    expect(page).to redirect_to new_guest_url
  end
end

describe InvitationsController, '.create' do
  context 'signed in as a user' do
    it 'redirects to the event page' do
      event_creator = create_user_and_sign_in
      event = create_event_and_mock_find(event_creator)

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: 'invitee@example.com' },
          invitation_text: 'Some text',
          event_id: event.id
        }

      expect(page).to redirect_to event_url(event.uuid)
    end

    it 'displays flash errors if the invitation does not save' do
      event_creator = create_user_and_sign_in
      event = create_event_and_mock_find(event_creator)
      expected_errors = 'Invitee email is not an email, Invitee is invalid'

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: 'invalid input' },
          invitation_text: 'invitation text',
          event_id: event.id
        }

      expect(flash[:error]).to eq expected_errors
    end

    it 'creates the appropriate invitation' do
      event_creator = create_user_and_sign_in
      event = create_event_and_mock_find(event_creator)
      invitee = create(:user)
      invitation_text = 'invitation text'

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: invitee.email },
          invitation_text: invitation_text,
          event_id: event.id
        }

      invitation = Invitation.find_by_invitee_id(invitee)

      expect(invitation.event_id).to eq event.id
      expect(invitation.invitation_text).to eq invitation_text
      expect(invitation.invitee_id).to eq invitee.id
      expect(invitation.invitee_type).to eq invitee.class.name
      expect(invitation.sender_id).to eq event_creator.id
      expect(invitation.sender_type).to eq event_creator.class.name
    end

    it 'creates multiple invitations when multiple guests are invited' do
      event_creator = create_user_and_sign_in
      event = create_event_and_mock_find(event_creator)
      emails = 'guest1@example.com, guest2@example.com'

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: emails },
          invitation_text: 'Some text',
          event_id: event.id
        }

      expect(Invitation.count).to eq 2
    end

    it 'creates multiple invitations for the correct users' do
      event_creator = create_user_and_sign_in
      event = create_event_and_mock_find(event_creator)
      invitation = stub('invitation', invite: nil, invalid?: false)
      emails = 'guest1@example.com, guest2@example.com'
      Invitation.stubs(new: invitation)
      invitee = stub('invitee')
      mock_invitee_builder(invitee)
      invitation_text = 'invitation text'

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: emails },
          invitation_text: invitation_text,
          event_id: event.id
        }

      expect(Invitation).to have_received(:new).with(
        event: event,
        invitee: invitee,
        invitation_text: invitation_text,
        sender: event_creator
      ).twice

      expect(invitation).to have_received(:invite).twice

      emails.split(', ').each do |email|
        expect(InviteeBuilder).to have_received(:new).with(email, event)
      end
    end

    def create_user_and_sign_in
      user = create(:user)
      sign_in_as(user)
      user
    end

    def create_event_and_mock_find(user)
      event = build_stubbed(:event, owner: user)
      Event.expects(:find).with(event.id.to_s).returns(event)
      event
    end

    def mock_invitee_builder(invitee)
      builder = stub('builder', find_user_by_email_or_create_guest: invitee)
      InviteeBuilder.stubs(new: builder)
    end
  end
end
