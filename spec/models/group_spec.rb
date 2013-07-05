require 'spec_helper'

describe Group do
  it { expect(subject).to validate_presence_of(:yammer_group_id) }
  it { expect(subject).to validate_presence_of(:name) }
end

describe Group, '#invite' do
  include DelayedJobSpecHelper

  it 'sends a private message if in-network' do
    invitee = build_stubbed(:group)
    invitation = build_stubbed(:invitation_with_group, invitee: invitee)
    owner = invitation.event.owner

    invitee.invite(invitation)
    work_off_delayed_jobs

    expect(FakeYammer.messages_endpoint_hits).to eq 1
  end
end

describe Group, '#has_voted_for_event?' do
  it 'always returns false' do
    group = build_stubbed(:group)
    event = build_stubbed(:event)

    expect(group.has_voted_for_event?(event)).to be_false
  end
end

describe Group, '#yammer_user?' do
  it 'always returns false' do
    group = build_stubbed(:group)

    expect(group.yammer_user?).to be_false
  end
end

describe Group, '#yammer_user_id' do
  it 'always returns nil' do
    group = build_stubbed(:group)

    expect(group.yammer_user_id).to be_nil
  end
end
