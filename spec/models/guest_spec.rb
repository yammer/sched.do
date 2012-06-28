require 'spec_helper'

describe Guest, 'validations' do
  it { should validate_presence_of(:email) }
  it { should have_many(:guest_votes) }
  it { should have_many(:votes).through(:guest_votes) }
  it { should have_many(:invitations) }
end

describe Guest, '.invite' do
  it 'creates a new invitation if the email does not have one' do
    event = create(:event)
    invitation = Guest.invite(event, 'something@example.com')
    Invitation.count.should == 1
  end

  it 'does not create a new invitation if one exists for the event and email' do
    event = create(:event)
    guest = create(:guest)
    invitation = Guest.invite(event, guest.email)
    repeated_invitation = Guest.invite(event, guest.email)
    repeated_invitation.should == invitation
  end

  it 'creates a new guest if there is none with the email address' do
    event = create(:event)
    invitation = Guest.invite(event, 'something@example.com')
    Guest.count.should == 1
  end

  it 'does not create a new guest if there is one with the email address' do
    event = create(:event)
    guest = create(:guest)
    invitation = Guest.invite(event, guest.email)
    Guest.all.should == [guest]
  end
end

describe Guest, '#guest?' do
  it 'always returns true' do
    build(:guest).should be_guest
  end
end

describe Guest, '#yammer_user?' do
  it 'always returns false' do
    build(:guest).should_not be_yammer_user
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
    guest_vote = create(:guest_vote, guest: guest)
    vote = create(:vote, votable: guest_vote)
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
    guest_vote = create(:guest_vote, guest: guest)
    vote = create(:vote, votable: guest_vote, suggestion: suggestion)
    guest.vote_for_suggestion(suggestion).should == vote
  end

  it 'returns nil if the guest has not voted on the suggestion' do
    guest = build(:guest)
    suggestion = create(:suggestion)
    guest.vote_for_suggestion(suggestion).should be_nil
  end
end

describe Guest, '#build_user_vote' do
  it 'return a new GuestVote instance with the correct guest' do
    guest = create(:guest)
    guest_vote = guest.build_user_vote
    guest_vote.guest.should == guest
  end
end
