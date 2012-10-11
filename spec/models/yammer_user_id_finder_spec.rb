require 'spec_helper'

describe YammerUserIdFinder, '#find' do
  it 'returns a Yammer user id if one exists' do
    yammer_user_email = 'ralph@example.com'
    user = build_stubbed(:user)
    id = 1488374236

    user_id_locator = YammerUserIdFinder.new(user, yammer_user_email)
    result = user_id_locator.find

    result.should == id
  end

  it 'returns nil if no Yammer user exists' do
    yammer_user_email = 'noone@example.com'
    user = build_stubbed(:user)

    result = YammerUserIdFinder.new(user, yammer_user_email).find

    result.should be_nil
  end

  it 'hits the Yammer API to find an existing user' do
    yammer_user_email = 'anyone@example.com'
    user = build_stubbed(:user)

    expect {
      result = YammerUserIdFinder.new(user, yammer_user_email).find
    }.to change(FakeYammer, :user_search_by_email_hits).by(1)
  end
end
