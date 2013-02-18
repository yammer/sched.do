require 'spec_helper'

describe Guest, 'validations' do
  it { expect(subject).to have_many(:invitations) }
  it { expect(subject).to have_many(:votes) }

  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).to validate_uniqueness_of(:email) }

  it 'requires a valid e-mail address' do
    expect(subject).to allow_value('person@example.com').for(:email)
    expect(subject).to allow_value('person-awesome@example.com').for(:email)
    expect(subject).to allow_value('person-awesome@example.co.ul.com').for(:email)
    expect(subject).to allow_value(' person@example.com').for(:email)
    expect(subject).to allow_value('person@example.com  ').for(:email)
    expect(subject).to_not allow_value('person@@example.com').for(:email)
    expect(subject).to_not allow_value('person').for(:email)
    expect(subject).to_not allow_value('person @person.com').for(:email)
  end

  context 'validates :name if has_ever_logged_in == true' do
    it 'is not valid without a name if has_ever_logged_in == true' do
      guest = build_stubbed(
        :guest,
        email: 'zip@email.com',
        name: nil,
        has_ever_logged_in: true
      )

      expect(guest).to_not be_valid
    end

    it 'is valid without a name if has_ever_logged_in == false' do
      guest = build_stubbed(
        :guest,
        email: 'zap@email.com',
        name: nil,
        has_ever_logged_in: false
      )

      expect(guest).to be_valid
    end
  end
end

describe Guest, '#normalize_email' do
  it 'trims white space from email' do
    guest = create(:guest, email: ' test@email.com ')

    expect(guest.email).to eq 'test@email.com'
  end

  it 'downcases email' do
    guest = create(:guest, email: 'Test@email.com')

    expect(guest.email).to eq 'test@email.com'
  end
end

describe Guest, '.find_or_initialize_by_email' do
  it 'initializes a guest with the given email and name' do
    guest = create(:guest)
    params = { email: guest.email, name: guest.name }

    initialized_guest = Guest.find_or_initialize_by_email(params)

    expect(initialized_guest.email).to eq guest.email
    expect(initialized_guest.name).to eq guest.name
  end

  it 'does not create duplicate guests with the same email' do
    guest = create(:guest)
    params = { email: guest.email, name: guest.name }

    duplicate_guest = Guest.find_or_initialize_by_email(params)

    expect {
      duplicate_guest.save
    }.to change(Guest, :count).by(0)
  end

  it 'allows guests with the same name and different emails' do
    guest = create(:guest)
    params = { email: 'different@email.com', name: guest.name }

    guest_with_same_name = Guest.find_or_initialize_by_email(params)

    expect {
      guest_with_same_name.save
    }.to change(Guest, :count).by(1)
  end
end

describe Guest, '#image' do
  it 'returns the placeholder image' do
    guest = build_stubbed(:guest)

    expect(guest.image).to eq 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end
end

describe Guest, '#vote_for_suggestion' do
  it "returns the user's vote for the given suggestion if the user has one" do
    user = create(:user)
    vote = create(:vote, voter: user)

    expect(user.vote_for_suggestion(vote.suggestion)).to eq vote
  end

  it 'returns nil if the user has not voted on the suggestion' do
    user = create(:user)
    suggestion = create(:suggestion)

    expect(user.vote_for_suggestion(suggestion)).to be_nil
  end
end

describe Guest, '#voted_for_suggestion?' do
  it 'returns true if the user voted for the suggestion' do
    user = create(:user)
    vote = create(:vote, voter: user)

    expect(user.voted_for_suggestion?(vote.suggestion)).to be_true
  end

  it 'returns false if the user did not vote for the suggestion' do
    user = create(:user)
    suggestion = create(:suggestion)

    expect(user.voted_for_suggestion?(suggestion)).to be_false
  end
end

describe User, '#voted_for_event?' do
  it 'returns true if the guest voted for the event' do
    guest = create(:guest)
    vote = create(:vote, voter: guest)

    expect(guest.voted_for_event?(vote.event)).to be_true
  end

  it 'returns false if the guest did not vote for the event' do
    guest = create(:guest)
    event = create(:event)

    expect(guest.voted_for_event?(event)).to be_false
  end
end

describe Guest, '#yammer_user?' do
  it 'always returns false' do
    expect(build(:guest)).to_not be_yammer_user
  end
end

describe Guest, '#yammer_user_id' do
  it 'always returns nil' do
    expect(build(:guest).yammer_user_id).to be_nil
  end
end

describe Guest, '#yammer_group_id' do
  it 'always returns nil' do
    expect(build(:guest).yammer_group_id).to be_nil
  end
end

describe Guest, '#able_to_edit?' do
  it 'always returns false' do
    event = build(:event)
    expect(build(:guest)).to_not be_able_to_edit(event)
  end
end

describe Guest, '#votes' do
  it "returns the guest's votes if there are any" do
    guest = create(:guest)
    vote = create(:vote, voter: guest)
    expect(guest.votes).to eq [vote]
  end

  it 'returns an empty array if the guest has no votes' do
    guest = build(:guest)
    expect(guest.votes).to eq []
  end
end
