require 'spec_helper'

describe Guest, 'validations' do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end

describe Guest, '#persisted?' do
  it 'always returns false' do
    guest = build(:guest)
    guest.persisted?.should == false
  end
end

describe Guest, '#guest?' do
  it 'always returns true' do
    guest = build(:guest)
    guest.guest?.should == true
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
    guest = build(:guest)
    guest_vote = create(:guest_vote, email: guest.email, name: guest.name)
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
    guest = build(:guest)
    suggestion = create(:suggestion)
    guest_vote = create(:guest_vote, email: guest.email, name: guest.name)
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
  it 'return a new GuestVote instance with the correct name and email' do
    guest = build(:guest)
    guest_vote = guest.build_user_vote
    guest_vote.name.should == guest.name
    guest_vote.email.should == guest.email
  end
end
