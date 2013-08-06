require 'spec_helper'

describe YammerUserInvitationsController, '.create' do
  it 'creates an Invitation for a yammer User' do
    event_creator = create_user_and_sign_in
    event = create(:event, owner: event_creator)
    invitee = create(:user)

    post :create,
      invitation: {
        invitation_text: 'Example text',
        invitee_attributes: { yammer_user_id: invitee.yammer_user_id },
        event_id: event.id
      }

    expect(Invitation.last.invitee).to eq invitee
  end

  it 'displays flash errors if the invitation does not save' do
    event_creator = create_user_and_sign_in
    event = create(:event, owner: event_creator)
    invalid_invitee_id = 'xyz'

    2.times do
      post :create,
        invitation: {
          invitation_text: 'Example text',
          invitee_attributes: { yammer_user_id: invalid_invitee_id },
          event_id: event.id
        }
    end

    expect(flash[:error]).to eq 'Invitee has already been invited'
  end

  def create_user_and_sign_in
    user = create(:user)
    sign_in_as(user)
  end
end
