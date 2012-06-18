require 'spec_helper'

describe User, 'validations' do
  it { should have_many(:events) }
  it { should have_many(:user_votes) }
  it { should have_many(:votes).through(:user_votes) }

  it { should validate_presence_of(:access_token) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:yammer_user_id) }

  it { should_not allow_mass_assignment_of(:salt) }

  context 'salt' do
    it 'sets a salt before validation on create' do
      user = User.new
      user.salt.should be_blank
      user.valid?
      user.salt.should be_present
    end

    it 'validates presence of salt' do
      user = create(:user)
      user.salt = ' '
      user.valid?
      user.errors[:salt].should include "can't be blank"
    end
  end

  context 'encrypted_access_token' do
    it 'encrypts access_token before validation on create' do
      access_token = 'abc123'
      salt = 'salt'
      expected_encrypted_access_token = Encrypter.new(access_token, salt).encrypt
      user = build(:user, access_token: access_token, salt: salt)

      user.encrypted_access_token.should be_blank
      user.save
      user.encrypted_access_token.should == expected_encrypted_access_token
    end

    it 'validates presence of encrypted_access_token' do
      user = create(:user)
      user.encrypted_access_token = ' '
      user.valid?
      user.errors[:encrypted_access_token].should include "can't be blank"
    end
  end
end

describe User, '.create_from_params' do
  it 'returns a new user' do
    auth = create_yammer_account
    user = User.create_from_params(auth)
    user.name.should == auth[:info][:name]
    user.access_token.should == auth[:info][:access_token]
    user.should be_persisted
  end
end

describe User, '#able_to_edit?' do
  it 'returns true if the user created the event' do
    event = create(:event)
    user = event.user
    event.user.should be_able_to_edit(event)
  end

  it 'returns false if the user did not create the event' do
    event = create(:event)
    build(:user).should_not be_able_to_edit(event)
  end
end

describe User, '#vote_for_suggestion' do
  it "returns the user's vote for the given suggestion if the user has one" do
    user = create(:user)
    suggestion = create(:suggestion)
    user_vote = create(:user_vote, user: user)
    vote = create(:vote, votable: user_vote, suggestion: suggestion)
    user.vote_for_suggestion(suggestion).should == vote
  end

  it 'returns nil if the user has not voted on the suggestion' do
    user = create(:user)
    suggestion = create(:suggestion)
    user.vote_for_suggestion(suggestion).should be_nil
  end
end

describe User, '#guest?' do
  it 'should always return false' do
    user = create(:user)
    user.guest?.should == false
  end
end

describe User, '#build_user_vote' do
  it 'returns a new UserVote instance with the correct user_id' do
    user = create(:user)
    user_vote = user.build_user_vote
    user_vote.user_id.should == user.id
  end
end
