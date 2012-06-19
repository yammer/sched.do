require 'spec_helper'

describe CurrentUser, '.find' do
  it 'finds the current user' do
    user = create(:user)
    token = user.encrypted_access_token
    name = 'John'
    email = generate(:email)
    CurrentUser.find(token, name, email).should == user
  end

  it 'returns a Guest if a User cannot be found' do
    token = 'invalid'
    name = 'John'
    email = generate(:email)
    guest = CurrentUser.find(token, name, email)
    guest.should be_guest
    guest.name.should == name
    guest.email.should == email
  end

  it 'returns a null user if a Guest or User cannot be found' do
    result = CurrentUser.find('invalid', nil, nil)
    result.should_not be_guest
    result.should_not be_yammer_user
  end
end
