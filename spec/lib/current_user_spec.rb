require 'spec_helper'

describe CurrentUser, '.find' do
  it 'finds the current user by UUID' do
    user = create(:user)
    yammer_user_id = user.yammer_user_id
    name = nil
    email = nil

    result = CurrentUser.find(yammer_user_id, name, email)

    result.class.should == User
    result.should == user
  end

  it 'returns a Guest if a User cannot be found' do
    yammer_user_id = 1001010101
    name = 'John'
    email = generate(:email)

    result = CurrentUser.find(yammer_user_id, name, email)

    result.class.should == Guest
    result.name.should == name
    result.email.should == email
  end

  it 'returns a null user if a Guest or User cannot be found' do
    result = CurrentUser.find('invalid', nil, nil)

    result.class.should == NullUser
  end
end
