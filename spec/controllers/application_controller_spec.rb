require 'spec_helper'

describe ApplicationController, '#current_user=' do
  it { should hide_action(:current_user=) }

  it 'returns true for the current user' do
    user = build_stubbed(:user)

    sign_in_as(user)

    current_user=(user).should be_true
  end

  it 'returns false for the other user' do
    user1 = build_stubbed(:user)
    user2 = build_stubbed(:user)

    sign_in_as(user1)

    current_user=(user2).should be_true
  end
end

describe ApplicationController, '#set_token_and_endpoint' do
  it 'configures Yammer to use the current user\'s token' do
    user = create(:user)
    sign_in_as(user)

    @controller.set_token_and_endpoint

    Yam.oauth_token.should == user.access_token
  end

  it 'configures Yammer with the event owner\'s token if a guest is logged in' do
    event = create(:event)
    session[:event_id] = event.uuid

    @controller.set_token_and_endpoint

    Yam.oauth_token.should == event.owner.access_token
  end

  it 'configures Yammer with the omniauth token if the user is singing in' do
    token = 'TOKEN'
    @controller.stubs(omniauth_token: token)

    @controller.set_token_and_endpoint

    Yam.oauth_token.should == token
  end
end

describe ApplicationController, '#check_blank_token' do
  it 'signs the user out if access_token is blank' do
    @controller.stubs(:redirect_to)
    user = create(:user)
    sign_in_as(user)
    user.access_token = 'EXPIRED'

    @controller.check_blank_token

    @controller.should have_received(:redirect_to).with(sign_out_path)
  end

  it 'does not sign the user out if access_token is present' do
    @controller.stubs(:redirect_to)
    user = create(:user)
    sign_in_as(user)
    user.access_token = '1234567890'

    @controller.check_blank_token

    @controller.should_not redirect_to(sign_out_path)
  end
end
