require 'spec_helper'

describe EventsController, 'authentication' do

  it 'requires yammer login for #new if you are coming from yammer' do
    get :new, from_yammer: true
    should redirect_to '/auth/yammer' 
  end

  it 'requires yammer login for #create if you are coming from yammer' do
    post :create, from_yammer: true
    should redirect_to '/auth/yammer' 
  end

  it 'requires yammer login for #edit if you are coming from yammer' do
    get :edit, id: 'LIUgiu6y', from_yammer: true
    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #update if you are coming from yammer' do
    put :update, id: 'LIUgiu6y', from_yammer: true
    should redirect_to '/auth/yammer' 
  end

  it 'requires yammer login for #new' do
    get :new
    should redirect_to '/auth/yammer' 
  end

  it 'requires yammer login for #create' do
    post :create
    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #edit' do
    get :edit, id: 'LIUgiu6y'
    should redirect_to '/auth/yammer'
  end

  it 'requires yammer login for #update' do
    put :update, id: 'LIUgiu6y'
    should redirect_to '/auth/yammer'
  end

  it 'requires login for #show' do
    get :show, id: 'LIUgiu6y'
    should redirect_to new_guest_url
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
