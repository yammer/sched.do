require 'spec_helper'

describe YammerGroupInvitationsController, '.create' do
  context 'signed in as a user' do
    it 'creates an Invitations for a Group' do
      create_user_and_sign_in
      group = create(:group)
      event = create(:event)

      post :create,
        invitation: {
          invitee_attributes: {
            yammer_group_id: group.yammer_group_id,
            name_or_email: group.name
          },
          event_id: event.id
        }

      Invitation.last.invitee.should == group
    end

    it 'displays flash errors if there is an issue creating an event' do
      create_user_and_sign_in
      group = create(:group)
      event = create(:event)

      2.times do
        post :create,
          invitation: {
            invitee_attributes: {
              yammer_group_id: group.yammer_group_id,
              name_or_email: group.name
            },
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
end
