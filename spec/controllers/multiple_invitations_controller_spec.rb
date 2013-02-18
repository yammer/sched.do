require 'spec_helper'

describe MultipleInvitationsController, '#new' do
  it 'instantiates an event scoped to the current user' do
    user = create(:user)
    users_event = create(:event, owner: user)
    sign_in_as(user)

    get :index, event_uuid: users_event.uuid

    expect(response).to be_success
    expect(assigns(:event).owner).to eq user
  end
end
