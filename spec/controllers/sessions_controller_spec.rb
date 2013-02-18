require 'spec_helper'

describe SessionsController, '#create' do
  include OmniAuthHelper

  it 'does not require login' do
    stub_omniauth_env

    post :create

    expect(page).to_not deny_access
  end

  it 'does not create a new user if one exists' do
    stub_omniauth_env

    post :create
    post :destroy
    post :create

    expect(User.count).to eq 1
  end

  it 'signs out a guest when a Yammer user signs in' do
    session[:name] = 'Joe Schmoe'
    session[:email] = 'joe@example.com'
    stub_omniauth_env

    post :create

    expect(session[:name]).to be_nil
    expect(session[:email]).to be_nil
  end

  it 'drops a yammer_user_id cookie' do
    expect(cookies.signed[:yammer_user_id]).to be_nil
    stub_omniauth_env

    post :create

    expect(cookies.signed[:yammer_user_id]).to be_present
  end

  it 'redirects to the new_event_path if return_to is blank' do
    session[:return_to] = nil
    stub_omniauth_env

    post :create

    expect(page).to redirect_to new_event_path
  end

  it 'deletes return_to if not blank' do
    session[:return_to] = new_event_path
    stub_omniauth_env

    post :create

    expect(session[:return_to]).to be_nil
  end
end


describe SessionsController, '#destroy' do
  include OmniAuthHelper

  it 'sets current_user to nil' do
    session[:name] = 'Joe Schmoe'
    session[:email] = 'joe@example.com'
    stub_omniauth_env

    delete :destroy

    expect(session[:name]).to be_nil
    expect(session[:email]).to be_nil
  end

  it 'deletes the yammer_user_id cookie' do
    cookies.signed[:yammer_user_id] = '123'

    delete :destroy

    expect(cookies.signed[:yammer_user_id]).to be_nil
  end

  it 'redirects to the root path' do
    stub_omniauth_env
    post :create

    delete :destroy

    expect(page).to redirect_to root_path
  end
end
