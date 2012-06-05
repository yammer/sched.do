require 'spec_helper'

describe User, 'validations' do
  it { should have_many(:votes) }

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
