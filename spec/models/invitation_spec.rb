require 'spec_helper'

describe Invitation do
  it { should belong_to(:event) }
  it { should belong_to(:user) }

  it { should allow_mass_assignment_of(:event_id) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:yammer_user_id) }

  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:name) }
end


describe Invitation, 'yammer_user_id' do
  it 'has an attr_accessor' do
    invitation = Invitation.new
    invitation.yammer_user_id = '123'
    invitation.yammer_user_id.should == '123'
  end

  it "uses the associated user's yammer_user_id if available" do
    user = create(:user)
    invitation = create(:invitation, user: user)
    invitation.yammer_user_id.should == user.yammer_user_id
  end
end

describe Invitation, 'before_save' do
  it 'sets the user based on yammer_user_id' do
    user = create(:user)
    invitation = create(:invitation, yammer_user_id: user.yammer_user_id)
    invitation.reload.user.should == user
  end

  it 'does not set the user if it cannot be found by yammer_user_id' do
    invitation = create(:invitation, yammer_user_id: nil)
    invitation.reload.user.should be_nil
  end
end
