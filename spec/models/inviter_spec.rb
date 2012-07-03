require 'spec_helper'

describe Inviter do
  let(:inviter) { Inviter.new(create(:event)) }

  it 'returns an invitation if the user exists' do
    user = create(:user)
    Invitation.count.should == 0
    invitation = inviter.invite_user(user)
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and user' do
    user = create(:user)
    original_invitation = inviter.invite_user(user)
    repeated_invitation = inviter.invite_user(user)
    repeated_invitation.should == original_invitation
  end

  context "given a yammer user_id and an email" do
    it "will create an invitation for the yammer user is possible" do
      yammer_user = create(:user)
      invitation = inviter.invite_unknown_yammer_user(yammer_user.yammer_user_id, "someone@example.com")
      yammer_user.invitations.should include(invitation)
    end

    it "will create an invitation for a yammer invitee if a yammer user is not found" do
      YammerInvitee.count.should == 0
      invitation = inviter.invite_unknown_yammer_user('yammer-user-id', 'someone@example.com')
      YammerInvitee.count.should == 1
    end
  end

  context "given a guest email" do
    it 'it creates a guest' do
      Guest.count.should == 0
      invitation = inviter.invite_guest_by_email('this_email_does_not_exist@example.com')
      Guest.count.should == 1
    end

    it 'will not create a new guest if one exists' do
      guest = create(:guest)
      Guest.count.should == 1
      invitation = inviter.invite_guest_by_email(guest.email)
      Guest.count.should == 1
    end
  end

  context "given a yammer user id" do
    it "creates an invitaiton is a user is found" do
      user = create(:user)
      invitation = inviter.invite_yammer_user_by_id(user.yammer_user_id)
      user.invitations.should include(invitation)
    end

    it 'returns nil and does not create an invitation if no user exists' do
      invitation = inviter.invite_yammer_user_by_id('non_existent_yammer_user_id')
      invitation.should be_nil
      Invitation.count.should == 0
    end
  end

  context "given a yammer invitee id" do
    it "creates a yammer invitee if one does not exit" do
      YammerInvitee.count.should == 0
      invitation = inviter.invite_yammer_invitee('yammer_user_id', 'Bruce Wayne')
      YammerInvitee.count.should == 1
    end

    it "uses the existing yammer invitee if it exists" do
      yammer_invitee = create(:yammer_invitee)
      YammerInvitee.count.should == 1
      invitation = inviter.invite_yammer_invitee(yammer_invitee.yammer_user_id, yammer_invitee.name)
      YammerInvitee.count.should == 1
    end
  end
end

describe Inviter, 'invite_unknown_user' do
  let(:inviter) { Inviter.new(create(:event)) }

  it "delegates to unknown_yammer_user if a yammer_user_id is passed" do
    inviter.stubs(:invite_unknown_yammer_user)
    inviter.invite_unknown_user("yammer-user-id", "someone@example.com")
    inviter.should have_received(:invite_unknown_yammer_user).with("yammer-user-id", "someone@example.com")
  end

  it "delegates to invite_guest_by_email if no yammer_user_id is passed" do
    inviter.stubs(:invite_guest_by_email)
    inviter.invite_unknown_user(nil, "someone@example.com")
    inviter.should have_received(:invite_guest_by_email).with("someone@example.com")
  end
end
