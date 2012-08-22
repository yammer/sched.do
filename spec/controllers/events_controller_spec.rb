require 'spec_helper'

describe EventsController, 'authentication' do
  YAMMER_USER_ID_FROM_FAKE = 'LIUgiu6y'

  it 'requires yammer login for #new' do
    get :new
    should redirect_to '/auth/yammer' 
  end

  it 'requires yammer login for #create' do
    post :create
    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #edit' do
    get :edit, id: YAMMER_USER_ID_FROM_FAKE
    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #update' do
    put :update, id: YAMMER_USER_ID_FROM_FAKE
    should redirect_to '/auth/yammer'
  end

  it 'requires guest or yammer login for #show' do
    get :show, id: YAMMER_USER_ID_FROM_FAKE
    should redirect_to new_guest_url(event_id: YAMMER_USER_ID_FROM_FAKE)
  end
end

describe EventsController, '#edit' do
  context 'with the user who created the event' do
    it 'is successful' do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(user)
      get :edit, id: event.uuid
      response.should be_success
    end
  end

  context 'with a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      get :edit, id: event.uuid
    end

    it 'redirects to the home page' do
      response.should redirect_to(root_path)
    end

    it 'tells the user that they are unauthorized' do
      should set_the_flash[:error].to(/not authorized/)
    end
  end
end

describe EventsController, '#show' do
  context 'with the user who created the event' do
    it 'is successful' do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(user)

      get :show, id: event.uuid

      response.should be_success
    end
  end

  context 'with a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      get :show, id: event.uuid
    end

    it 'shows the page' do
      response.should be_success
    end
  end

  context 'use an invalid uuid as the user who created the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      fake_uuid = 'fakefake'
      sign_in_as(user)
      get :show, id: fake_uuid
    end

    it 'redirects you to the show page' do
      response.should redirect_to(root_path)
    end

    it 'tells the user that they are unauthorized' do
      should set_the_flash[:error].to(/not authorized/)
    end
  end

  context 'use an invalid uuid as a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      fake_uuid = 'fakefake'
      get :show, id: fake_uuid
    end

    it 'redirects you to the show page' do
      response.should redirect_to(root_path)
    end

    it 'tells the user that they are unauthorized' do
      should set_the_flash[:error].to(/not authorized/)
    end
  end
end

describe EventsController, '#update' do
  context 'with the user who created the event' do
    let!(:event) { create(:event) }
    let!(:user) { event.user }

    before do
      sign_in_as(user)
    end

    it 'is successful' do
      put :update, id: event.uuid
      response.should redirect_to(event)
    end
  end

  context 'with a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      put :update, id: event.uuid
    end

    it 'redirects to the home page' do
      response.should redirect_to(root_path)
    end

    it 'tells the user that they are unauthorized' do
      should set_the_flash[:error].to(/not authorized/)
    end
  end
end
