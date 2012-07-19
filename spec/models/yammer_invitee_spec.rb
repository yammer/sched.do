require 'spec_helper'

describe YammerInvitee, 'validations' do
  it { should have_many(:invitations) }

  it { should allow_mass_assignment_of(:yammer_user_id) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:yammer_user_id) }
end

describe YammerInvitee, '.convert_to_user_from_params' do
  it 'returns false if it finds no YammerInvitee' do
    YammerInvitee.convert_to_user_from_params({ uid: 'non_existent_yammer_user_id' }).should == nil
  end

  it 'returns a User and destroys the YammerInvitee if one is found' do
    yammer_invitee = create(:yammer_invitee)
    params = create_yammer_account_with_yammer_user_id(yammer_invitee.yammer_user_id)
    YammerInvitee.count.should == 1
    user = YammerInvitee.convert_to_user_from_params(params)
    user.should == User.find_by_yammer_user_id(params[:uid])
    YammerInvitee.count.should == 0
  end

  it "converts the YammerInvitee's invitations to the User" do
    yammer_invitee = create(:yammer_invitee)
    create_list(:invitation_with_yammer_invitee, 2, invitee: yammer_invitee)
    params = create_yammer_account_with_yammer_user_id(yammer_invitee.yammer_user_id)
    user = YammerInvitee.convert_to_user_from_params(params)
    Invitation.count.should == 2
    Invitation.all.each do |invitation|
      invitation.invitee.should == user
    end
  end
end

describe YammerInvitee, '#notify' do
  it 'delivers a private message' do
    yammer_invitee = create(:yammer_invitee)
    invitee = create(:yammer_invitee)

    invitation = build(:invitation_with_yammer_invitee, invitee: invitee)
    ap invitation

    yammer_invitee.notify(invitation)

    FakeYammer.messages_endpoint_hits.should == 1
  end
end
