require 'spec_helper'

describe MultipleInvitationsController, '#new' do
  it 'instantiates an event scoped to the current user' do
    user = create(:user)
    users_event = create(:event, owner: user)
    sign_in_as(user)

    get :index, event_uuid: users_event.uuid

    response.should be_success
    assigns(:event).owner.should == user
  end
end
