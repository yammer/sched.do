require 'spec_helper'

describe YammerUser, '.find_or_create' do
  it 'finds a user if one already exists using the yammer_user_id' do
    user = create(:user)
    auth = {
      access_token: 'ZZZZZZ',
      yammer_staging: user.yammer_staging?,
      yammer_user_id: user.yammer_user_id
    }

    found_user = YammerUser.new(auth).find_or_create

    found_user.should == user
    found_user.access_token.should == auth[:access_token]
  end

  it 'creates a new user if one does not exist' do
    auth = {
      access_token: 'NCC1701',
      yammer_staging: false,
      yammer_user_id: 321123
    }

    lambda {
      YammerUser.new(auth).find_or_create
    }.should change(User, :count).by(1)
  end

  it 'sets the right attributes for the new user' do
    auth = {
      access_token: 'ASF444',
      yammer_staging: false,
      yammer_user_id: 321123
    }

    YammerUser.new(auth).find_or_create

    user = User.last
    user.yammer_user_id.should == auth[:yammer_user_id]
    user.access_token.should == auth[:access_token]
    user.yammer_staging.should == auth[:yammer_staging]
  end

  it 'calls associate_guest_invitations' do
    User.any_instance.stubs(:associate_guest_invitations)
    auth = {
      access_token: 'PUH98h',
      yammer_staging: false,
      yammer_user_id: 123321
    }

    YammerUser.new(auth).find_or_create

    User.any_instance.should have_received(:associate_guest_invitations)
  end
end
