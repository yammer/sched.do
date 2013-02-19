require 'spec_helper'

describe EventsController, 'authentication' do
  YAMMER_EVENT_ID_FROM_FAKE = 'LIUgiu6y'

  it 'requires yammer login for #new' do
    get :new

    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #create' do
    post :create

    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #edit' do
    get :edit, id: YAMMER_EVENT_ID_FROM_FAKE

    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #update' do
    put :update, id: YAMMER_EVENT_ID_FROM_FAKE

    should redirect_to '/auth/yammer'
  end

  it 'requires guest or yammer login for #show' do
    get :show, id: YAMMER_EVENT_ID_FROM_FAKE

    should redirect_to new_guest_url(event_id: YAMMER_EVENT_ID_FROM_FAKE)
  end
end

describe EventsController, '#create' do
  it 'sets the owner to the current user' do
    user = create(:user)
    sign_in_as(user)

    post :create, event: { name: 'test event' }

    assigns(:event).owner.should == user
  end

  it 'redirects to MultipleInvitationsController#new' do
    sign_in_as(create(:user))
    event = build_stubbed(:event)
    event.stubs(save: true)
    Event.stubs(new: event)

    post :create, event: { name: event.name }

    should redirect_to "/multiple_invitations?event_uuid=#{event.uuid}"
  end
end

describe EventsController, '#edit' do
  context 'with the user who created the event' do
    it 'is successful' do
      user = create(:user)
      event = create(:event, owner: user)
      sign_in_as(user)

      get :edit, id: event.uuid

      response.should be_success
    end
  end

  context 'with a user who did not create the event' do
    it 'should raise ActiveRecord::RecordNotFound' do
      user = create(:user)
      event = create(:event, owner: user)
      sign_in_as(create(:user))

      sign_in_as(create(:user))

      lambda { get :update, id: event.uuid }.
        should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

describe EventsController, '#show' do
  context 'with the user who created the event' do
    it 'is successful' do
      user = create(:user)
      event = create(:event, owner: user)
      sign_in_as(user)

      get :show, id: event.uuid

      response.should be_success
    end
  end

  context 'with a user who did not create the event' do
    it 'shows the page' do
      user = create(:user)
      event = create(:event, owner: user)
      another_user = create(:user)
      sign_in_as(another_user)

      get :show, id: event.uuid

      response.should be_success
    end
  end

  context 'use an invalid uuid as the user who created the event' do
    it 'raises a RecordNotFound error' do
      user = create(:user)
      event = create(:event, owner: user)
      fake_uuid = 'fakefake'

      sign_in_as(user)

      lambda { get :show, id: fake_uuid }.
        should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'use an invalid uuid as a user who did not create the event' do
    it 'should raise ActiveRecord::RecordNotFound' do
      user = create(:user)
      event = create(:event, owner: user)
      sign_in_as(create(:user))
      fake_uuid = 'fakefake'

      lambda { get :show, id: fake_uuid }.
        should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

describe EventsController, '#update' do
  context 'with the user who created the event' do
    it 'is successful' do
      event = create(:event)
      user = event.owner
      sign_in_as(user)

      put :update, event: { name: 'new name' }, id: event.uuid

      response.should redirect_to(event)
    end
  end

  context 'with a user who did not create the event' do
    it 'should raise ActiveRecord::RecordNotFound' do
      user = create(:user)
      event = create(:event, owner: user)

      sign_in_as(create(:user))

      lambda { put :update, id: event.uuid }.
        should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
