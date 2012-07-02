require 'spec_helper'

describe EventsController, 'authentication' do
  it 'requires login for #new' do
    get :new
    should deny_access
  end

  it 'requires login for #create' do
    post :create
    should deny_access
  end

  it 'requires login for #show' do
    get :show, id: 1
    should redirect_to new_guest_url
  end

  it 'requires login for #edit' do
    get :edit, id: 1
    should deny_access
  end

  it 'requires login for #update' do
    put :update, id: 1
    should deny_access
  end
end

describe EventsController, '#edit' do
  context 'with the user who created the event' do
    it 'is successful' do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(user)
      get :edit, id: event.id
      response.should be_success
    end
  end

  context 'with a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      get :edit, id: event.id
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
      put :update, id: event.id
      response.should redirect_to(event)
    end

    it 'accepts nested attributes for invitations' do
      invitations_attributes = { '0' => { name_or_email: 'John Smith' } }
      put :update, id: event.id, event: { invitations_attributes: invitations_attributes }
      response.should redirect_to(event)
      Invitation.count.should == 1
    end

    it 'ignores blank invitations' do
      invitations_attributes = { '0' => { name_or_email: 'John Smith' }, '1' => { name_or_email: '' }}
      put :update, id: event.id, event: { invitations_attributes: invitations_attributes }
      Invitation.count.should == 1
    end
  end

  context 'with a user who did not create the event' do
    before do
      user = create(:user)
      event = create(:event, user: user)
      sign_in_as(create(:user))
      put :update, id: event.id
    end

    it 'redirects to the home page' do
      response.should redirect_to(root_path)
    end

    it 'tells the user that they are unauthorized' do
      should set_the_flash[:error].to(/not authorized/)
    end
  end
end
