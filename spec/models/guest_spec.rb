require 'spec_helper'

describe Guest, 'validations' do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:invitations) }

  it "requires a valid e-mail address" do
    should allow_value("person@example.com").for(:email)
    should allow_value("person-awesome@example.com").for(:email)
    should allow_value("person-awesome@example.co.ul.com").for(:email)
    should allow_value(" person@example.com").for(:email)
    should allow_value("person@example.com  ").for(:email)
    should_not allow_value("person@@example.com").for(:email)
    should_not allow_value("person").for(:email)
    should_not allow_value("person @person.com").for(:email)
  end
end

describe Guest, '.initialize_with_name_and_email' do
  it 'initializes a guest with the given email and name' do
    guest = create(:guest)
    params = { guest: { email: guest.email, name: guest.name } }

    initialized_guest = Guest.initialize_with_name_and_email(params)

    initialized_guest.email.should == guest.email
    initialized_guest.name.should == guest.name
  end

  it 'does not create duplicate guests with the same email' do
    guest = create(:guest)
    params = { guest: { email: guest.email, name: guest.name } }

    duplicate_guest = Guest.initialize_with_name_and_email(params)

    lambda {
      duplicate_guest.save
    }.should change(Guest, :count).by(0)
  end

  it 'allows guests with the same name and different emails' do
    guest = create(:guest)
    params = { guest: { email: 'different@email.com', name: guest.name } }

    guest_with_same_name = Guest.initialize_with_name_and_email(params)

    lambda {
      guest_with_same_name.save
    }.should change(Guest, :count).by(1)
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

describe Guest, '#vote_for_suggestion' do
  it "returns the user's vote for the given suggestion if the user has one" do
    user = create(:user)
    vote = create(:vote, voter: user)

    user.vote_for_suggestion(vote.suggestion).should == vote
  end

  it 'returns nil if the user has not voted on the suggestion' do
    user = create(:user)
    suggestion = create(:suggestion)

    user.vote_for_suggestion(suggestion).should be_nil
  end
end

describe Guest, '#voted_for_suggestion?' do
  it "returns true if the user voted for the suggestion" do
    user = create(:user)
    vote = create(:vote, voter: user)

    user.voted_for_suggestion?(vote.suggestion).should be_true
  end

  it "returns false if the user did not vote for the suggestion" do
    user = create(:user)
    suggestion = create(:suggestion)

    user.voted_for_suggestion?(suggestion).should be_false
  end
end

describe User, '#voted_for_event?' do
  it "returns true if the guest voted for the event" do
    guest = create(:guest)
    vote = create(:vote, voter: guest)

    guest.voted_for_event?(vote.event).should be_true
  end

  it "returns false if the guest did not vote for the event" do
    guest = create(:guest)
    event = create(:event)

    guest.voted_for_event?(event).should be_false
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
