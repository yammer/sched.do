require 'spec_helper'

describe ApplicationController, '#current_user=' do
  it { expect(subject).to hide_action(:current_user=) }

  it 'returns true for the current user' do
    user = build_stubbed(:user)

    sign_in_as(user)

    expect(current_user=(user)).to be_true
  end

  it 'returns false for the other user' do
    user1 = build_stubbed(:user)
    user2 = build_stubbed(:user)

    sign_in_as(user1)

    expect(current_user=(user2)).to be_true
  end
end
