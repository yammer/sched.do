require 'spec_helper'

describe Inviter do
  let(:inviter) { Inviter.new(create(:event)) }

  it 'returns an invitation if the user exists' do
    user = create(:user)
    Invitation.count.should == 0
    invitation = inviter.invite(user)
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and user' do
    user = create(:user)
    original_invitation = inviter.invite(user)
    repeated_invitation = inviter.invite(user)
    repeated_invitation.should == original_invitation
  end

  context "given a yammer user_id and an email" do
    it "will create an invitation for the yammer user is possible" do
      yammer_user = create(:user)
      invitation = inviter.invite_from_params(yammer_user_id: yammer_user.yammer_user_id)
      yammer_user.invitations.should include(invitation)
    end

    it "will create an invitation for a yammer invitee if a yammer user is not found" do
      YammerInvitee.count.should == 0
      invitation = inviter.invite_from_params(yammer_user_id: 'yammer-user-id', name_or_email: 'someone@example.com')
      YammerInvitee.count.should == 1
    end
  end

  context "given a guest email with no current yammer user" do
    it 'it creates a guest' do
      Guest.count.should == 0
      invitation = inviter.invite_from_params(name_or_email: 'this_email_does_not_exist@example.com')
      Guest.count.should == 1
    end

    it 'will not create a new guest if one exists' do
      guest = create(:guest)
      Guest.count.should == 1
      invitation = inviter.invite_from_params(name_or_email:guest.email)
      Guest.count.should == 1
    end
  end

  context "given a yammer user id" do
    it "creates an invitation is a user is found" do
      user = create(:user)
      invitation = inviter.invite_from_params(yammer_user_id: user.yammer_user_id)
      user.invitations.should include(invitation)
    end

    it "will create a guest if the yammer_user_id is blank" do
      Guest.count.should == 0
      invitiation = inviter.invite_from_params(yammer_user_id: '', name_or_email: 'test@example.com')
      Guest.count.should == 1
    end
  end

  context "given a yammer invitee id" do
    it "creates a yammer invitee if one does not exit" do
      YammerInvitee.count.should == 0
      invitation = inviter.invite_from_params(yammer_user_id: 'yammer_user_id', name_or_email: 'Bruce Wayne')
      YammerInvitee.count.should == 1
    end

    it "uses the existing yammer invitee if it exists" do
      yammer_invitee = create(:yammer_invitee)
      YammerInvitee.count.should == 1
      invitation = inviter.invite_from_params(yammer_user_id: yammer_invitee.yammer_user_id, name_or_email: yammer_invitee.name)
      YammerInvitee.count.should == 1
    end
  end

  context "with no yammer_user_id and no email" do
    it "should not create an invitation" do
      Invitation.count.should == 0
      invitation = inviter.invite_from_params(yammer_user_id: '', name_or_email: '')
      Invitation.count.should == 0
    end
  end
end
