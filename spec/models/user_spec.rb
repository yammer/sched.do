require 'spec_helper'

describe User, 'validations' do
  it { should have_many(:events) }
  it { should have_many(:user_votes) }
  it { should have_many(:votes).through(:user_votes) }
  it { should have_many(:invitations) }

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

describe User, '.create_from_params!' do
  it 'returns a new user' do
    auth = create_yammer_account
    user = User.create_from_params!(auth)

    user.access_token.should == auth[:info][:access_token]
    user.email.should == auth[:info][:email]
    user.name.should == auth[:info][:name]
    user.nickname.should == auth[:info][:nickname]
    user.image.should == auth[:info][:image]
    user.yammer_profile_url.should == auth[:info][:yammer_profile_url]
    user.yammer_user_id.should == auth[:uid]
    user.extra.should_not be nil

    user.should be_persisted
  end

  it 'updates Yammer.com account information on login' do
    auth = create_yammer_account
    user = User.create_from_params!(auth)

    rename_yammer_account('Adam West')

    user.update_yammer_info(auth)

    user.name.should == auth[:info][:name]
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
    vote = create(:vote_by_user, user: user)
    user.vote_for_suggestion(vote.suggestion).should == vote
  end

  it 'returns nil if the user has not voted on the suggestion' do
    user = create(:user)
    suggestion = create(:suggestion)
    user.vote_for_suggestion(suggestion).should be_nil
  end
end

describe User, '#voted_for?' do
  it "returns true if the user voted for the suggestion" do
    user = create(:user)
    vote = create(:vote_by_user, user: user)
    user.voted_for?(vote.suggestion).should be_true
  end

  it "returns false if the user did not vote for the suggestion" do
    user = create(:user)
    suggestion = create(:suggestion)
    user.voted_for?(suggestion).should be_false
  end
end

describe User, '#guest?' do
  it 'always returns false' do
    build(:user).should_not be_guest
  end
end

describe User, '#yammer_user?' do
  it 'always returns true' do
    build(:user).should be_yammer_user
  end
end

describe User, '#build_user_vote' do
  it 'returns a new UserVote instance with the correct user_id' do
    user = create(:user)
    user_vote = user.build_user_vote
    user_vote.user_id.should == user.id
  end
end

describe User, '#create_yammer_activity' do
  it 'creates a Yammer activity story' do
    FakeYammer.activity_endpoint_hits.should == 0
    user = build_stubbed(:user)
    event = build_stubbed(:event)
    event.generate_uuid

    user.create_yammer_activity('update', event)

    FakeYammer.activity_endpoint_hits.should == 1
  end
end

describe User, '#notify' do
  it 'sends a private message notification' do
    invitee = build_stubbed(:user)
    invitation = build_stubbed(:invitation_with_user,
                               invitee: invitee)

    invitee.notify(invitation)

    FakeYammer.messages_endpoint_hits.should == 1
    FakeYammer.message.should include(invitation.event.name)
  end
end
