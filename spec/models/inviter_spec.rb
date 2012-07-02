require 'spec_helper'

describe Inviter, 'invite_user' do
  before(:each) do
    event = create(:event)
    @inviter = Inviter.new(event)
  end

  it 'returns an invitation if the user exists' do
    Invitation.count.should == 0
    user = create(:user)
    invitation = @inviter.invite_user(user.yammer_user_id)
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and yammer_user_id' do
    user = create(:user)
    original_invitation = @inviter.invite_user(user.yammer_user_id)
    repeated_invitation = @inviter.invite_user(user.yammer_user_id)
    repeated_invitation.should == original_invitation
  end

  it 'returns nil and does not create an invitation if no user exists' do
    invitation = @inviter.invite_user('non_existant_yammer_user_id')
    invitation.should be_nil
    Invitation.count.should == 0
  end
end

describe Inviter, 'invite_yammer_invitee' do
  before(:each) do
    event = create(:event)
    @inviter = Inviter.new(event)
  end

  it 'returns an invitation' do
    Invitation.count.should == 0
    invitation = @inviter.invite_yammer_invitee('yammer_user_id', 'Bruce Wayne')
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and yammer_user_id' do
    yammer_invitee = create(:yammer_invitee)
    original_invitation = @inviter.invite_yammer_invitee(yammer_invitee.yammer_user_id, yammer_invitee.name)
    repeated_invitation = @inviter.invite_yammer_invitee(yammer_invitee.yammer_user_id, yammer_invitee.name)
    repeated_invitation.should == original_invitation
  end

  it 'creates a new YammerInvitee if one does not exist for the yammer_user_id' do
    YammerInvitee.count.should == 0
    invitation = @inviter.invite_yammer_invitee('non_existant_yammer_user_id', 'Bruce Wayne')
    YammerInvitee.count.should == 1
  end

  it 'does not create a new YammerInvitee if one exists for the yammer_user_id' do
    yammer_invitee = create(:yammer_invitee)
    YammerInvitee.count.should == 1
    invitation = @inviter.invite_yammer_invitee(yammer_invitee.yammer_user_id, yammer_invitee.name)
    YammerInvitee.count.should == 1
  end
end


describe Inviter, 'invite_guest' do
  before(:each) do
    event = create(:event)
    @inviter = Inviter.new(event)
  end

  it 'returns an invitation' do
    Invitation.count.should == 0
    invitation = @inviter.invite_guest('batman@example.com')
    Invitation.count.should == 1
  end

  it 'creates a new Guest if one does not exist for the email' do
    Guest.count.should == 0
    invitation = @inviter.invite_guest('this_email_does_not_exist@example.com')
    Guest.count.should == 1
  end

  it 'does not create a new Guest if one exists for the email' do
    guest = create(:guest)
    Guest.count.should == 1
    invitation = @inviter.invite_guest(guest.email)
    Guest.count.should == 1
  end
end
