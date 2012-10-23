require 'spec_helper'

describe InvitationsController, 'authentication' do
  it 'requires guest or yammer login for #create' do
    post :create

    should redirect_to new_guest_url
  end
end

describe InvitationsController, '.create' do
  it 'redirects to the event page' do
    user = create(:user)
    sign_in_as(user)
    event = create(:event, owner: user)

    post :create, invitation: { event_id: event.id }

    should redirect_to event_url(event.uuid)
  end

  it 'displays flash errors if the invitation does not save' do
    user = create(:user)
    sign_in_as(user)
    event = create(:event, owner: user)

    post :create, invitation: { event_id: event.id }

    flash[:error].should == 'Invitee is invalid'
  end

  it 'creates the appropriate invitation' do
    user = create(:user)
    sign_in_as(user)
    event = create(:event, owner: user)
    invitee = create(:user)

    post :create,
      invitation: {
        invitee_attributes: { name_or_email: invitee.email },
        event_id: event.id
      }

    invitation = Invitation.find_by_invitee_id(invitee)

    invitation.event_id.should == event.id
    invitation.invitee_id.should == invitee.id
    invitation.invitee_type.should == invitee.class.name
    invitation.sender_id.should == user.id
    invitation.sender_type.should == user.class.name
  end
end
