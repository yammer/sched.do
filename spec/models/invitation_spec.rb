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

  it 'is valid if the event owner is not invited' do
    user = create(:user)
    invitation = build_stubbed(:invitation, invitee: user)

    invitation.should be_valid
  end

  it 'is invalid if the invitee was already invited' do
    event = create(:event)
    user = create(:user)

    first_invitation = create(:invitation, event: event, invitee: user)
    second_invitation = build_stubbed(:invitation, event: event, invitee: user)

    second_invitation.should be_invalid
  end
end

describe Invitation, '#create' do
  it 'creates a delayed job' do
    InvitationCreatedJob.stubs(:enqueue)
  end

  it 'invite_without_notification does not notify the invitee' do
    user = create(:user)
    event = create(:event)
    user.stubs(:deliver_email_or_private_message)

    Invitation.invite_without_notification(event, user)

    user.should have_received(:deliver_email_or_private_message).never  end
end

describe Invitation, 'build_invitee' do
  context 'given a yammer user_id and an email' do
    it 'will create an invitation for the yammer user if possible' do
      yammer_user = create(:user)
      invitation = create(:invitation)

      invitation.build_invitee( { yammer_user_id: yammer_user.yammer_user_id } )
      invitation.save

      yammer_user.invitations.should include(invitation)
    end

    it 'will create a user if one does not exist given a yammer_user_id' do
      invitation = create(:invitation)
      invited_yammer_user_id = 'LIBu6'
      User.find_by_yammer_user_id(invited_yammer_user_id).should be_nil

      invitation.build_invitee({yammer_user_id: invited_yammer_user_id})
      invitation.save

      user = User.find_by_yammer_user_id(invited_yammer_user_id)
      user.should_not be_nil
      user.invitations.should include(invitation)
    end
  end

  context 'given a yammer group_id' do
    it 'will create an invitation for an existing yammer group' do
      group = create(:group)
      invitation = create(:invitation)

      invitation.build_invitee(yammer_group_id: group.yammer_group_id)
      invitation.save

      group.invitations.should include(invitation)
    end

    it 'will create and invite a group if the group does not already exist' do
      yammer_group_name = 'Group Name'
      invitation = create(:invitation)

      invitation.build_invitee(
        yammer_group_id: 'yammer-group-id',
        name_or_email: yammer_group_name
      )

      Group.count.should == 1
      Group.first.name.should == yammer_group_name
    end
  end

  context 'given an email with no current yammer user id or group id' do
    it 'searches for a user by email' do
      guest = build_stubbed(:guest)
      user = build_stubbed(:user)
      User.stubs(:find_by_email)
      invitation = create(:invitation)

      invitation.build_invitee(name_or_email: user.email)

      User.should have_received(:find_by_email).with(user.email)
      Guest.should have_received(:find_by_email).with(guest.email).never
    end

    it 'find a guest by email if one exists' do
      invitation = create(:invitation)
      guest = build_stubbed(:guest)
      Guest.stubs(:find_by_email)

      invitation.build_invitee(name_or_email: guest.email)

      Guest.should have_received(:find_by_email).with(guest.email)
    end

    it 'search for an existing User by email' do
      invitation = create(:invitation)
      user_email = 'ralph@thoughtbot.com'
      User.stubs(:find_by_email)

      invitation.build_invitee(name_or_email: user_email)

      User.should have_received(:find_by_email).with(user_email)
    end

    it 'searches for existing Yammer users if they exist' do
      invitation = create(:invitation)
      access_token = invitation.sender.access_token
      invitee_email = 'horace@example.com'
      User.stubs(:find_existing_yammer_user_id)

      invitation.build_invitee(name_or_email: invitee_email)

      User.should have_received(:find_existing_yammer_user_id).
        with(invitee_email, access_token)
    end

    it 'creates a guest' do
      invitation = create(:invitation)
      Guest.stubs(:create_without_name_validation)
      email = 'george@example.com'

      invitation.build_invitee(name_or_email: email)

      Guest.should have_received(:create_without_name_validation).with(email)
    end
  end

  context 'given a yammer user id' do
    it 'creates an invitation is a user is found' do
      user = create(:user)
      invitation = create(:invitation)

      invitation.build_invitee(yammer_user_id: user.yammer_user_id)
      invitation.save

      user.invitations.should include(invitation)
    end

    it 'will create a guest if the yammer_user_id is blank' do
      Guest.stubs(:create_without_name_validation)
      invitation = create(:invitation)
      email = 'george@example.com'

      invitation.build_invitee(yammer_user_id: '', name_or_email: email)

      Guest.should have_received(:create_without_name_validation).with(email)
    end
  end

  context 'with no yammer_user_id and no email' do
    it 'does not create an invitation' do
      invitation = build(:invitation)

      expect {
        invitation.build_invitee(yammer_user_id: '', name_or_email: '')
        invitation.save
      }.not_to change(Invitation, :count)
    end
  end
end

describe Invitation, '#sender' do
  it 'tell you who created the invitations event' do
    invitation = build_stubbed(:invitation_with_user)

    invitation.sender.should == invitation.event.owner
  end
end
