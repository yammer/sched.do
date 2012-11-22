require 'spec_helper'

describe YammerGroupInvitationsController, '.create' do
  context 'signed in as a user' do
    it 'creates an Invitations for a Group' do
      event_creator = create_user_and_sign_in
      event = build_stubbed(:event, owner: event_creator)
      group = create(:group, yammer_group_id: 12345, name: 'my group')

      Group.expects(:find_or_create_by_yammer_group_id).
        with(yammer_group_id: group.yammer_group_id.to_s, name: group.name).
        returns(group)

      Invitation.expects(:new).
        with(event_id: event.id.to_s, invitee: group, sender: event_creator).
        returns(mock('invitation', save: true, event: event))

      post :create,
        invitation: {
          invitee_attributes: {
            yammer_group_id: group.yammer_group_id,
            name_or_email: group.name
          },
          event_id: event.id
        }
    end

    it 'displays flash errors if there is an issue creating an event' do
      event_creator = create_user_and_sign_in
      event = build_stubbed(:event, owner: event_creator)
      group = create(:group, yammer_group_id: 12345, name: 'my group')

      Group.expects(:find_or_create_by_yammer_group_id).
        with(yammer_group_id: group.yammer_group_id.to_s, name: group.name).
        returns(group)

      Invitation.expects(:new).
        with(event_id: event.id.to_s, invitee: group, sender: event_creator).
        returns(
          mock(
            'invitation', save: false, event: event, errors: mock(
              'errors', full_messages: mock(
                'full messages', last: 'error'
              )
            )
          )
        )

      post :create,
        invitation: {
          invitee_attributes: {
            yammer_group_id: group.yammer_group_id,
            name_or_email: group.name
          },
          event_id: event.id
        }

      flash[:error].should == 'error'
    end

    def create_user_and_sign_in
      user = create(:user)
      sign_in_as(user)
      user
    end
  end
end
