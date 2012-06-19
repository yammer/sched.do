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

  it 'returns nil if a Guest or User cannot be found' do
    CurrentUser.find('invalid', nil, nil).should be_nil
  end
end
