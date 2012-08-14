require 'spec_helper'

describe CurrentUser, '.find' do
  it 'finds the current user' do
    user = create(:user)
    yammer_user_id = user.yammer_user_id
    name = 'John'

    email = generate(:email)

    CurrentUser.find(yammer_user_id, name, email).should == user
  end

  it 'returns a Guest if a User cannot be found' do
    yammer_user_id = 1001010101
    name = 'John'
    email = generate(:email)

    guest = CurrentUser.find(yammer_user_id, name, email)

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
