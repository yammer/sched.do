require 'spec_helper'

describe InvitationsController, 'authentication' do
  it 'requires guest or yammer login for #create' do
    post :create

    expect(page).to redirect_to new_guest_url
  end
end

describe InvitationsController, '#create' do
  context 'signed in as a user' do
    it 'redirects to the event page' do
      event_creator = create_user_and_sign_in
      event = create(:event, owner: event_creator)

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
      event = create(:event, owner: event_creator)
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
      event = create(:event, owner: event_creator)
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
      event = create(:event, owner: event_creator)
      emails = 'guest1@example.com, guest2@example.com'

      post :create,
        invitation: {
          invitee_attributes: { name_or_email: emails },
          invitation_text: 'Some text',
          event_id: event.id
        }

      expect(Invitation.count).to eq 3
    end

    it 'creates multiple invitations for the correct users' do
      event_creator = create_user_and_sign_in
      event = create(:event, owner: event_creator)
      invitation = double(invite: nil, invite: nil, valid?: true)
      emails = 'guest1@example.com, guest2@example.com'
      Invitation.stub(new: invitation)
      invitee = double
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

    def mock_invitee_builder(invitee)
      builder = double(find_user_by_email_or_create_guest: invitee)
      InviteeBuilder.stub(new: builder)
    end
  end
end

describe InvitationsController, '#destroy' do
  context 'as event creator' do
    it 'deletes invitation for an invited user' do
      invitation = create(:invitation)
      sign_in_as(invitation.event.owner)

      delete :destroy, id: invitation.id

      expect(response).to redirect_to(event_path(invitation.event))
      expect { invitation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'cannot delete invitation for the event creator' do
      event = create(:event)
      invitation = event.owner.invitations.first
      sign_in_as(event.owner)

      delete :destroy, id: invitation.id
      expect(response).to redirect_to(event_path(invitation.event))
      expect(invitation.reload).to be_present
    end
  end

  context 'as invited guest' do
    it 'deletes invitation for the current user' do
      invitation = create(:invitation)
      sign_in_as(invitation.invitee)

      delete :destroy, id: invitation.id

      expect(response).to redirect_to(polls_path)
      expect { invitation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'cannot delete invitation for another user' do
      invitation = create(:invitation)
      user = create(:user)
      sign_in_as(user)

      delete :destroy, id: invitation.id

      expect(invitation.reload).to be_present
    end
  end

  context 'as invited guest' do
    it 'deletes invitation for the logged in invitee' do
      invitation = create(:invitation_with_guest)
      sign_in_as(invitation.invitee)

      delete :destroy, id: invitation.id

      expect(response).to redirect_to(root_path)
      expect { invitation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'deletes votes for the logged in invitee' do
      vote = create(:vote)
      invitation = vote.voter.invitations.first
      sign_in_as(vote.voter)

      delete :destroy, id: invitation.id

      expect { vote.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
