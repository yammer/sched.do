require 'spec_helper'

describe SessionsController, '#create' do
  it 'does not require login' do
    stub_omniauth_env
    post :create
    should_not deny_access
  end

  it 'does not create a new user if one exists' do
    stub_omniauth_env
    post :create
    post :destroy
    post :create
    User.count.should == 1
  end

  it 'signs out a guest when a yammer user signs in' do
    session[:name] = 'Joe Schmoe'
    session[:email] = 'joe@example.com'
    stub_omniauth_env
    post :create

    session[:name].should be_nil
    session[:email].should be_nil
  end

  private

  def stub_omniauth_env
    request.env['omniauth.auth'] = OmniAuth.mock_auth_for(:yammer)
  end

  def stub_declined_tos
    request.env['omniauth.params'] = { "agree_to_tos" => "0" }
  end
end
