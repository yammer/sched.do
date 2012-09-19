require 'spec_helper'

describe Group do
  it { should validate_presence_of(:yammer_group_id) }
  it { should validate_presence_of(:name) }
end

describe Group, '#yammer_user?' do
  it 'always returns false' do
    group = build_stubbed(:group)

    group.yammer_user?.should be_false
  end
end

describe Group, '#yammer_user_id' do
  it 'always returns nil' do
    group = build_stubbed(:group)

    group.yammer_user_id.should be_nil
  end
end

describe Group, '#deliver_email_or_private_message' do
  include DelayedJobSpecHelper

  it 'it sends a private message' do
    group = create(:group)
    invitation = build(:invitation_with_group, invitee: group)

    group.deliver_email_or_private_message(
      :invitation,
      invitation.event.owner,
      invitation
    )
    work_off_delayed_jobs

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include(invitation.event.name)
  end
end
