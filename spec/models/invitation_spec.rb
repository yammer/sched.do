require 'spec_helper'

describe Invitation do
  it { should belong_to(:event) }
  it { should belong_to(:invitee) }

  it { should accept_nested_attributes_for :invitee }

  it { should allow_mass_assignment_of(:event) }
  it { should allow_mass_assignment_of(:invitee) }

  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:invitee_id) }
  it { should validate_presence_of(:invitee_type) }

  it 'should notify the invitee after creation' do
    user = create(:user)
    user.stubs(:notify)
    invitation = build(:invitation, invitee: user)

    invitation.save

    user.should have_received(:notify)
  end
end


describe Invitation, '.find_or_create_by_event_and_invitee' do
  it 'does not create an invitation if one exists' do
    user = create(:user)
    event = create(:event)
    invitation = create(:invitation_with_user, event: event, invitee: user)
    Invitation.find_or_create_by_event_and_invitee(event, user).should == invitation
  end

  it 'creates an invitation if one does not exists' do
    user = create(:user)
    event = create(:event)
    Invitation.find_or_create_by_event_and_invitee(event, user)
    Invitation.count.should == 1
  end
end

describe Invitation, '#name_or_email' do
  it 'returns a name if the invitee has one' do
    invitation = build(:invitation_with_user)
    invitation.name_or_email.should == invitation.invitee.name
  end

  it 'returns an email if the invitee has no name' do
    invitation = build(:invitation_with_guest)
    invitation.name_or_email.should == invitation.invitee.email
  end

  it 'returns nil if there is no invitee' do
    invitation = build(:invitation)
    invitation.name_or_email.should == nil
  end
end

describe Invitation, '#yammer_user_id' do
  it 'should return the yammer_user_id if the invitee has one' do
    invitation = build(:invitation_with_user)
    invitation.yammer_user_id.should == invitation.invitee.yammer_user_id
  end

  it 'should return nil if the invitee has no yammer_user_id' do
    invitation = build(:invitation_with_guest)
    invitation.yammer_user_id.should == nil
  end

  it 'should return nil if there is no invitee' do
    invitation = build(:invitation)
    invitation.yammer_user_id.should == nil
  end
end

describe Invitation, '#yammer_group_id' do
  it 'should return the yammer_group_id if the invitee has one' do
    invitation = build(:invitation_with_group)
    invitation.yammer_group_id.should == invitation.invitee.yammer_group_id
  end

  it 'should return nil if the invitee has no yammer_group_id' do
    invitation = build(:invitation_with_guest)
    invitation.yammer_group_id.should == nil
  end

  it 'should return nil if there is no invitee' do
    invitation = build(:invitation)
    invitation.yammer_group_id.should == nil
  end
end
