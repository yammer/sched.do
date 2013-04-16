require 'spec_helper'

describe UsersController do
  describe '#show' do
    context 'with a signed in user' do
      it 'is successful' do
        user = create(:user)
        sign_in_as(user)

        get :show

        expect(response).to be_success
      end

      it 'sets the events variable to the users sorted events' do
        user = create(:user)
        user_event = create(:event, owner: user)
        invitation = create(:invitation, invitee: user)

        sign_in_as(user)

        get :show

        expect(assigns(:events)).to eq([invitation.event, user_event])
      end
    end

    context 'not signed in' do
      it 'requires yammer login for #update' do
        get :show

        expect(page).to redirect_to '/auth/yammer'
      end
    end
  end
end
