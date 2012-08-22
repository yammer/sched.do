require 'spec_helper'

describe ApplicationController, '#current_user=' do
  it { should hide_action(:current_user=) }

  it 'should return true for the current user' do
    user = create(:user)
    sign_in_as(user)

    current_user=(user).should be_true
  end

  it 'should return false for the another user' do
    user1 = create(:user)
    user2 = create(:user)
    sign_in_as(user1)

    current_user=(user2).should be_true
  end
end
