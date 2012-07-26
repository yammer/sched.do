require 'spec_helper'

describe Event do
  it { should belong_to(:user) }
  it { should have_many(:suggestions) }
  it { should have_many(:votes).through(:suggestions) }
  it { should have_many(:invitations) }
  it { should have_many(:users).through(:invitations) }
  it { should have_many(:yammer_invitees).through(:invitations) }
  it { should have_many(:guests).through(:invitations) }
  it { should have_many(:groups).through(:invitations) }

  it { should validate_presence_of(:name).with_message(/This field is required/) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:user_id) }

  it { should allow_mass_assignment_of(:suggestion) }
  it { should allow_mass_assignment_of(:suggestions_attributes) }

  it { should accept_nested_attributes_for(:suggestions).allow_destroy(true) }

  it "should allow the event to have 1 or more suggestions" do
    event = create(:event)
    event.suggestions.destroy_all

    event.valid?.should == true
  end
  it "should not allow the event to have no suggestions" do
    event = create(:event)
    event.valid?.should == false
  end

  it 'rejects blank suggestions' do
    nested_attributes_options = Event.nested_attributes_options[:suggestions]
    nested_attributes_options[:reject_if].call({ primary: '' }).should be_true
  end

  it 'updates Yammer activity ticker after creation' do
    FakeYammer.activity_endpoint_hits.should == 0

    event = create(:event)

    FakeYammer.activity_endpoint_hits.should == 1
  end

  it 'has a uuid after creation' do
    event = create(:event)
    event.uuid.length.should eq(8)
  end
end

describe Event, '#invitees' do
  it 'returns the event creator and users, yammer_invitees, and guests invited to the event' do
    event = create(:event)
    invitees = [event.user]
    invitees += create_list(:invitation_with_user, 2, event: event).map(&:invitee)
    invitees += create_list(:invitation_with_yammer_invitee, 2, event: event).map(&:invitee)
    invitees += create_list(:invitation_with_guest, 2, event: event).map(&:invitee)
    event.reload

    event.invitees.should =~ invitees
  end

  it 'returns only the event creator if there are no invitees' do
    event = build(:event)
    event.invitees.should == [event.user]
  end

  it "returns invitees with the newest first" do
    event = create(:event)
    first_invitee = create(:invitation_with_user, event: event).invitee
    second_invitee = create(:invitation_with_user, event: event).invitee
    event.reload

    event.invitees.should == [second_invitee, first_invitee, event.user]
  end
end

describe Event, '#user_voted?' do
  it 'returns true if the user has voted on the event' do
    event = create(:event)
    user = event.user
    suggestion = create(:suggestion, event: event)
    vote = create(:vote_by_user, user: user, suggestion: suggestion)

    event.user_voted?(user).should be_true
  end

  it 'returns false if the user has not voted on the event' do
    event = create(:event)
    user = event.user
    suggestion = create(:suggestion, event: event)

    event.user_voted?(user).should be_false
  end
end

describe Event, '#user_owner?' do
  it 'returns true if the user is the owner of the event' do
    event = create(:event)
    user = event.user

    event.should be_user_owner(user)
  end

  it 'returns false if the user is not the owner of the event' do
    event = create(:event)

    event.should_not be_user_owner(build(:user))
  end
end

describe Event, '#user_votes' do
    it 'does not return an event\'s votes for a user unless they voted' do
    event = create(:event)
    user = event.user
    suggestion = create(:suggestion, event: event)
    vote = create(:vote_by_user, suggestion: suggestion)

    event.user_votes(user).should_not include(vote)
  end

  it 'returns an events votes for a specific user if they voted' do
    event = create(:event)
    user = event.user
    suggestion = create(:suggestion, event: event)
    vote = create(:vote_by_user, user: user, suggestion: suggestion)

    event.user_votes(user).should include(vote)
  end
end
