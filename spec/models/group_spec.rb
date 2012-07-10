require 'spec_helper'

describe Group do
  it { should validate_presence_of(:yammer_group_id) }
  it { should validate_presence_of(:name) }

  it "should notify users via a group message" do
    group = create(:group)
    invitation = create(:invitation, invitee: group)
    group.notify(invitation)
    pending "This will notify via yammer api but is currently a placeholder"
  end
end
