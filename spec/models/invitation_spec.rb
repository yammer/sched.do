require 'spec_helper'

describe Invitation do
  it { should belong_to(:event) }
  it { should belong_to(:invitee) }

  it { should accept_nested_attributes_for :invitee }

  it { should allow_mass_assignment_of(:event) }
  it { should allow_mass_assignment_of(:invitee) }

  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:invitee_id).with_message(/is invalid/) }
  it { should validate_presence_of(:invitee_type) }

  it 'should be valid if the event owner is not invited' do
    user = create(:user)
    invitation = build_stubbed(:invitation, invitee: user)

    invitation.should be_valid
  end

  it 'should be invalid if the event owner is invited' do
    event = create(:event)
    invitation = build_stubbed(:invitation, event: event, invitee: event.user)

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
    invitation = build(:invitation_with_group, invitee: group)

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

describe Invitation, '#name_or_email' do
  it 'returns a name if the invitee has one' do
    invitation = build_stubbed(:invitation_with_user)

    invitation.name_or_email.should == invitation.invitee.name
  end

  it 'returns an email if the invitee has no name' do
    invitation = build_stubbed(:invitation_with_guest)
    guest = invitation.invitee
    guest.name = nil

    invitation.name_or_email.should == invitation.invitee.email
    invitation.invitee.name.should be_nil
  end

  it 'returns nil if there is no invitee' do
    invitation = build_stubbed(:invitation, invitee: nil)

    invitation.name_or_email.should == nil
  end
end

describe Invitation, '#sender' do
  it 'should tell you who created the invitations event' do
    invitation = build_stubbed(:invitation_with_user)

    invitation.sender.should == invitation.event.user
  end
end

describe Invitation, '#yammer_group_id' do
  it 'should return the yammer_group_id if the invitee has one' do
    invitation = build_stubbed(:invitation_with_group)

    invitation.yammer_group_id.should == invitation.invitee.yammer_group_id
  end

  it 'should return nil if the invitee has no yammer_group_id' do
    invitation = build_stubbed(:invitation_with_guest)

    invitation.yammer_group_id.should == nil
  end

  it 'should return nil if there is no invitee' do
    invitation = build_stubbed(:invitation)

    invitation.yammer_group_id.should == nil
  end
end

describe Invitation, '#yammer_user_id' do
  it 'should return the yammer_user_id if the invitee has one' do
    invitation = build_stubbed(:invitation_with_user)

    invitation.yammer_user_id.should == invitation.invitee.yammer_user_id
  end

  it 'should return nil if the invitee has no yammer_user_id' do
    invitation = build_stubbed(:invitation_with_guest)

    invitation.yammer_user_id.should == nil
  end

  it 'should return nil if there is no invitee' do
    invitation = build_stubbed(:invitation, invitee: nil)

    invitation.yammer_user_id.should == nil
  end
end

describe Invitation do
  let (:user) { create(:user) }
  let (:event) { create(:event) }
  let (:invitation) { build(:invitation) }
  let (:yammer_user) { create(:user) }
  let (:group) { create(:group) }

  context "given a yammer user_id and an email" do
    it "will create an invitation for the yammer user if possible" do
      invitation.build_invitee( { yammer_user_id: yammer_user.yammer_user_id } )

      invitation.save

      yammer_user.invitations.should include(invitation)
    end

    it 'will create a user if one does not exist given a yammer_user_id' do
      invited_yammer_user_id = 'LIBu6'
      User.find_by_yammer_user_id(invited_yammer_user_id).should be_nil

      invitation.build_invitee({yammer_user_id: invited_yammer_user_id})
      invitation.save

      user = User.find_by_yammer_user_id(invited_yammer_user_id)
      user.should_not be_nil
      user.invitations.should include(invitation)
    end
  end

  context "given a yammer group_id" do
    it "will create an invitation for an existing yammer group" do
      invitation.build_invitee(yammer_group_id: group.yammer_group_id)

      invitation.save

      group.invitations.should include(invitation)
    end

    it "will create a group and attach an invitation to it if the group does not already exist" do
      yammer_group_name = 'Group Name'

      invitation.build_invitee(yammer_group_id: 'yammer-group-id', name_or_email: yammer_group_name)

      Group.count.should == 1
      Group.first.name.should == yammer_group_name
    end
  end

  context "given a guest email with no current yammer user" do
    it 'creates a guest' do
      Guest.stubs(:create_without_name_validation)

      invitation.build_invitee(name_or_email: 'george@example.com')

      Guest.should have_received(:create_without_name_validation).
        with('george@example.com')
    end

    it 'will not create a new guest if one exists' do
      guest = create(:guest)
      Guest.stubs(:find_by_email)

      invitation.build_invitee(name_or_email: guest.email)

      Guest.should have_received(:find_by_email).
        with(guest.email)
    end
  end

  context "given a yammer user id" do
    it "creates an invitation is a user is found" do
      user = create(:user)
      invitation.build_invitee(yammer_user_id: user.yammer_user_id)

      invitation.save

      user.invitations.should include(invitation)
    end

    it "will create a guest if the yammer_user_id is blank" do
      Guest.stubs(:create_without_name_validation)

      invitation.build_invitee(
        yammer_user_id: '',
        name_or_email: 'george@example.com'
      )

      Guest.should have_received(:create_without_name_validation).
        with('george@example.com')
    end
  end

  context "with no yammer_user_id and no email" do
    it "should not create an invitation" do
      Invitation.count.should == 0
      invitation.build_invitee(yammer_user_id: '', name_or_email: '')

      invitation.save

      Invitation.count.should == 0
    end
  end
end
