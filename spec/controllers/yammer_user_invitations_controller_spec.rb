require 'spec_helper'

describe YammerUserInvitationsController, '.create' do
  it 'creates an Invitation for a yammer User' do
    event_creator = create_user_and_sign_in
    event = create(:event, owner: event_creator)
    invitee = create(:user)

    post :create,
      invitation: {
        invitee_attributes: { yammer_user_id: invitee.yammer_user_id },
        event_id: event.id
      }

    Invitation.count.should == 2
    Invitation.last.invitee_id.should == invitee.id
  end

  it 'displays flash errors if the invitation does not save' do
    event_creator = create_user_and_sign_in
    event = create(:event, owner: event_creator)
    invalid_invitee_id = 'xyz'

    2.times do
      post :create,
        invitation: {
          invitee_attributes: { yammer_user_id: invalid_invitee_id },
          event_id: event.id
        }
    end

    flash[:error].should == 'Invitee has already been invited'
  end

  def create_user_and_sign_in
    user = create(:user)
    sign_in_as(user)
    user
  end
end
