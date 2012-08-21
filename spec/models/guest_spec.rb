require 'spec_helper'

describe Guest, 'validations' do
  it { should validate_presence_of(:email) }
  it { should have_many(:invitations) }

  it "requires a valid e-mail address" do
    should allow_value("person@example.com").for(:email)
    should allow_value("person-awesome@example.com").for(:email)
    should allow_value("person-awesome@example.co.ul.com").for(:email)
    should_not allow_value("person@@example.com").for(:email)
    should_not allow_value("person").for(:email)
    should_not allow_value("person @person.com").for(:email)
  end
end

describe Guest, '#guest?' do
  it 'always returns true' do
    build(:guest).should be_guest
  end
end

describe Guest, 'image' do
  it 'returns the placeholder image' do
    guest = build_stubbed(:guest)

    guest.image.should == 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end
end

describe Guest, '#yammer_user?' do
  it 'always returns false' do
    build(:guest).should_not be_yammer_user
  end
end

describe Guest, '#yammer_user_id' do
  it 'always returns nil' do
    build(:guest).yammer_user_id.should be_nil
  end
end

describe Guest, '#yammer_group_id' do
  it 'always returns nil' do
    build(:guest).yammer_group_id.should be_nil
  end
end


describe Guest, '#able_to_edit?' do
  it 'always returns false' do
    event = build(:event)
    build(:guest).should_not be_able_to_edit(event)
  end
end

describe Guest, '#votes' do
  it "returns the guest's votes if there are any" do
    guest = create(:guest)
    vote = create(:vote, voter: guest)
    guest.votes.should == [vote]
  end

  it "returns an empty array if the guest has no votes" do
    guest = build(:guest)
    guest.votes.should == []
  end
end

describe Guest, '#vote_for_suggestion' do
  it "returns the guest's vote for the given suggestion if the guest has one" do
    guest = create(:guest)
    suggestion = create(:suggestion)
    vote = create(:vote, suggestion: suggestion, voter: guest)
    guest.vote_for_suggestion(suggestion).should == vote
  end

  it 'returns nil if the guest has not voted on the suggestion' do
    guest = build(:guest)
    suggestion = create(:suggestion)
    guest.vote_for_suggestion(suggestion).should be_nil
  end
end


describe Guest, '#notify' do
  include DelayedJobSpecHelper

  it 'delivers the invitation email' do
    guest = create(:guest)
    invitation = build(:invitation_with_guest, invitee: guest)
    mailer = stub('mailer', deliver: true)
    UserMailer.stubs(invitation: mailer)

    guest.notify(invitation)
    work_off_delayed_jobs

    UserMailer.should have_received(:invitation).with(guest, invitation.event)
    mailer.should have_received(:deliver).once
  end
end
