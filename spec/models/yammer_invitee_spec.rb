require 'spec_helper'

describe YammerInvitee, 'validations' do
  it { should have_many(:invitations) }

  it { should allow_mass_assignment_of(:yammer_user_id) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:yammer_user_id) }
end

describe YammerInvitee, '.invite' do
  it 'creates a new invitation' do
    event = create(:event)
    invitation = YammerInvitee.invite(event, { yammer_user_id: 'nonexistant_yammer_id', name_or_email: 'Joe' })
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and yammer_user_id' do
    event = create(:event)
    yammer_invitee = create(:yammer_invitee)
    invitation = YammerInvitee.invite(event, yammer_user_id: yammer_invitee.yammer_user_id)
    repeated_invitation = YammerInvitee.invite(event, yammer_user_id: yammer_invitee.yammer_user_id)
    repeated_invitation.should == invitation
  end

  it 'creates a new YammerInvitee if one does not exist for the yammer_user_id' do
    event = create(:event)
    invitation = YammerInvitee.invite(event, { yammer_user_id: 'nonexistant_yammer_id', name_or_email: 'Joe' })
    YammerInvitee.count.should == 1
  end

  it 'does not create a new YammerInvitee if one exists for the yammer_user_id' do
    event = create(:event)
    yammer_invitee = create(:yammer_invitee)
    invitation = YammerInvitee.invite(event, { yammer_user_id: yammer_invitee.yammer_user_id, name_or_email: 'Joe' })
    YammerInvitee.all.should == [yammer_invitee]
  end
end
