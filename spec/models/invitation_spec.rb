require 'spec_helper'

describe Invitation do
  it { should belong_to(:event) }
  it { should belong_to(:invitee) }
  it { should belong_to(:sender) }

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
  context 'given a Yammer user_id and an email' do
    it 'will create an invitation for the Yammer user if possible' do
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

  context 'given a Yammer group_id' do
    it 'will create an invitation for an existing Yammer group' do
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

  context 'given an email with no current yammer_user_id or group_id' do
    it 'searches for a user by email' do
      invitation = create(:invitation)
      guest = build_stubbed(:guest)
      user = build_stubbed(:user)
      User.stubs(:find_by_email)

      invitation.build_invitee(name_or_email: user.email)

      User.should have_received(:find_by_email).with(user.email)
      Guest.should have_received(:find_by_email).with(guest.email).never
    end

    it 'searches for a Guest by email if no User exists' do
      invitation = create(:invitation)
      guest = build_stubbed(:guest)
      Guest.stubs(:find_by_email)

      invitation.build_invitee(name_or_email: guest.email)

      Guest.should have_received(:find_by_email).with(guest.email)
    end

    it 'searches for existing Yammer users' do
      invitation = create(:invitation)
      access_token = invitation.sender.access_token
      invitee_email = 'ralph@example.com'
      YammerUserIdFinder.any_instance.stubs(:find)

      invitation.build_invitee(name_or_email: invitee_email)

      YammerUserIdFinder.any_instance.should have_received(:find)
    end

    it 'creates a User if it finds an existing Yammer user' do
      invitation = create(:invitation)
      access_token = invitation.access_token
      yammer_staging = false
      invitee_email = 'ralph@example.com'
      invitee_user_id = 1488374236
      User.stubs(:find_or_create_with_auth)

      invitation.build_invitee(name_or_email: invitee_email)

      User.should have_received(:find_or_create_with_auth).
        with(access_token: access_token,
             yammer_staging: yammer_staging,
             yammer_user_id: invitee_user_id)
    end

    it 'creates a guest' do
      invitation = create(:invitation)
      Guest.stubs(:create_without_name_validation)
      email = 'george@example.com'

      invitation.build_invitee(name_or_email: email)

      Guest.should have_received(:create_without_name_validation).with(email)
    end
  end

  context 'given a Yammer user id' do
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

describe Invitation, '#deliver_reminder_from' do
  it 'sends a reminder to the invitee' do
    invitation = create(:invitation)
    invitee = invitation.invitee
    invitee.stubs(:deliver_email_or_private_message)
    sender = create(:user)

    invitation.deliver_reminder_from(sender)

    invitee.should have_received(:deliver_email_or_private_message).once
  end
end
