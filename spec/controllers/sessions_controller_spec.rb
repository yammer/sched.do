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

  it 'converts YammerInvitees to Users' do
    yammer_invitee = create(:yammer_invitee)
    stub_omniauth_env_with_yammer_invitee(yammer_invitee)
    [User.count, YammerInvitee.count].should == [0, 1]
    post :create
    [User.count, YammerInvitee.count].should == [1, 0]
  end

  private

  def stub_omniauth_env
    request.env['omniauth.auth'] = OmniAuth.mock_auth_for(:yammer)
  end

  def stub_omniauth_env_with_yammer_invitee(yammer_invitee)
    request.env['omniauth.auth'] = OmniAuth.mock_auth_for(:yammer).merge!({
      uid: yammer_invitee.yammer_user_id
    })
  end
end
