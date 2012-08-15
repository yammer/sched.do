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

  it 'should be valid if the event owner is not invited' do
    user = create(:user)
    invitation = build(:invitation, invitee: user)

    invitation.should be_valid
  end

  it 'should be invalid if the event owner is invited' do
    event = create(:event)
    invitation = build(:invitation, event: event, invitee: event.user)

    invitation.should be_invalid
  end

  it 'should notify the invitee after creation' do
    user = create(:user)
    user.stubs(:notify)
    invitation = build(:invitation, invitee: user)

    invitation.save

    user.should have_received(:notify)
  end

  it 'should notify a group after creation' do
    group = create(:group)
    group.stubs(:notify)
    invitation = build(:invitation, invitee: group)

    invitation.save

    group.should have_received(:notify)
  end

  it 'invite_without_notification should not notify the invitee' do
    user = create(:user)
    event = create(:event)

    user.stubs(:notify)

    Invitation.invite_without_notification(event, user)

    user.should have_received(:notify).never
  end
end

describe Invitation, '#invite' do
  it 'calls find_or_create_by_event_id_and_invitee_id_and_invitee_type ' do
    user = create(:user)
    event = create(:event)
    Invitation.stubs(:find_or_create_by_event_id_and_invitee_id_and_invitee_type)

    Invitation.invite(event, user)

    Invitation.should have_received(
      :find_or_create_by_event_id_and_invitee_id_and_invitee_type).
        with(event.id, user.id, user.class.name)
  end
end

describe Invitation, '#name_or_email' do
  it 'returns a name if the invitee has one' do
    invitation = build(:invitation_with_user)
    invitation.name_or_email.should == invitation.invitee.name
  end

  it 'returns an email if the invitee has no name' do
    invitation = build(:invitation_with_guest_without_name)
    invitation.name_or_email.should == invitation.invitee.email
  end

  it 'returns nil if there is no invitee' do
    invitation = build(:invitation)
    invitation.name_or_email.should == nil
  end
end

describe Invitation, '#sender' do
  it 'should tell you who created the invitations event' do
    invitation = build(:invitation_with_user)
    invitation.sender.should == invitation.event.user
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

describe Invitation do
  let (:user) { create(:user) }
  let (:event) { create(:event) }
  let (:yammer_user) { create(:user) }
  let (:group) { create(:group) }

  it 'returns an invitation if the user exists' do
    lambda{
      Invitation.invite(event, user)
    }.should change(Invitation,:count).by(1)
  end

  it 'does not create a new invitation if one exists for the event and user' do
    original_invitation = Invitation.invite(event, user)
    repeated_invitation = Invitation.invite(event, user)
    repeated_invitation.should == original_invitation
  end

  context "given a yammer user_id and an email" do
    it "will create an invitation for the yammer user is possible" do

      invitation = Invitation.invite_from_params(event, {yammer_user_id: yammer_user.yammer_user_id})

      yammer_user.invitations.should include(invitation)
    end

    it 'will create a user if one does not exist given a yammer_user_id' do
      invited_yammer_user_id = 'LIBu6'
      User.find_by_yammer_user_id(invited_yammer_user_id).should be_nil

      invitation =
        Invitation.invite_from_params(event, {yammer_user_id: invited_yammer_user_id})

      user = User.find_by_yammer_user_id(invited_yammer_user_id)
      user.should_not be_nil
      user.invitations.should include(invitation)
    end
  end

  context "given a yammer group_id" do
    it "will create an invitation for an existing yammer group" do
      invitation = Invitation.invite_from_params(event, yammer_group_id: group.yammer_group_id)
      group.invitations.should include(invitation)
    end

    it "will create a group and attach an invitation to it if the group does not already exist" do
      yammer_group_name = 'Group Name'
      invitation = Invitation.invite_from_params(event, yammer_group_id: 'yammer-group-id', name_or_email: yammer_group_name)
      Group.count.should == 1
      Group.first.name.should == yammer_group_name
    end
  end

  context "given a guest email with no current yammer user" do
    it 'it creates a guest' do
      lambda{
        invitation = Invitation.invite_from_params(event, name_or_email: 'this_email_does_not_exist@example.com')
      }.should change(Guest,:count).by(1)
    end

    it 'will not create a new guest if one exists' do
      guest = create(:guest)
      lambda{
        invitation = Invitation.invite_from_params(event, name_or_email:guest.email)
      }.should_not change(Guest,:count)
    end
  end

  context "given a yammer user id" do
    it "creates an invitation is a user is found" do
      user = create(:user)
      invitation = Invitation.invite_from_params(event, yammer_user_id: user.yammer_user_id)
      user.invitations.should include(invitation)
    end

    it "will create a guest if the yammer_user_id is blank" do
      lambda{
        Invitation.invite_from_params(event, yammer_user_id: '', name_or_email: 'test@example.com')
      }.should change(Guest,:count).by(1)
    end
  end

  context "with no yammer_user_id and no email" do
    it "should not create an invitation" do
      lambda{ 
        Invitation.invite_from_params(event, yammer_user_id: '', name_or_email: '')
      }.should_not change(Invitation,:count)
    end
  end
end
