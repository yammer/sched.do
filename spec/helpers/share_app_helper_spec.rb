require 'spec_helper'

describe ShareAppHelper, 'share_app_default_text' do
  it 'returns the correct string with the owner is sharing the app' do
    user = build_stubbed(:user)
    event = build(:event, owner: user)

    default_text = share_app_default_text(event, user)

    expect(default_text).to eq 'I created an event in sched.do - a free tool you can use to create polls, schedule events, etc. Create your own polls at https://www.sched.do/!'
  end

  it 'returns the correct string when the user sharing the app is not the owner' do
    user = build_stubbed(:user)
    event = build(:event)

    default_text = share_app_default_text(event, user)

    expect(default_text).to eq 'I voted on an event in sched.do - a free tool you can use to create polls, schedule events, etc. Create your own polls at https://www.sched.do/!'
  end
end
