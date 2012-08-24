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

  context 'when coming from yammer.com' do
    before do
      stub_previous_site_as_yammer
      stub_omniauth_env
      post :create
    end

    it 'sets the referer variable as yammer' do
      session[:referer].should == 'yammer'
    end
  end

  context 'when coming from staging.yammer.com' do
    before do
      stub_previous_site_as_yammer_staging
      stub_omniauth_env
      post :create
    end

    it 'sets the referer variable as yammer-staging' do
      session[:referer].should == 'staging'
    end
  end

  context 'when coming from a non-yammer site' do
    before do
      stub_previous_site_as_non_yammer
      stub_omniauth_env
      post :create
    end

    it 'does not set the referer variable' do
      session[:referer].should be_nil
    end
  end

  context 'when coming to sched.do from a fresh browser' do
    before do
      stub_previous_site_as_nil
      stub_omniauth_env
      post :create
    end

    it 'does not set the referer variable' do
      session[:referer].should be_nil
    end
  end

  private

  def stub_omniauth_env
    request.env['omniauth.auth'] = OmniAuth.mock_auth_for(:yammer)
  end

  def stub_previous_site_as_nil
    request.env["HTTP_REFERER"] = nil
  end

  def stub_previous_site_as_non_yammer
    request.env["HTTP_REFERER"] = 'http://learn.thoughtbot.com/'
  end

  def stub_previous_site_as_yammer
    request.env["HTTP_REFERER"] = 'https://www.yammer.com/company.com/'
  end

  def stub_previous_site_as_yammer_staging
    request.env["HTTP_REFERER"] = 'https://www.staging.yammer.com/company.com/'
  end
end
