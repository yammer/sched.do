require 'spec_helper'

describe User, 'accessors' do
  it { expect(subject).to allow_mass_assignment_of(:access_token) }
  it { expect(subject).to allow_mass_assignment_of(:encrypted_access_token) }
  it { expect(subject).to allow_mass_assignment_of(:name) }
  it { expect(subject).to allow_mass_assignment_of(:yammer_user_id) }
  it { expect(subject).to allow_mass_assignment_of(:yammer_staging) }
  it { expect(subject).to allow_mass_assignment_of(:watermarked_image) }
end

describe User, 'validations' do
  it { expect(subject).to have_many(:events) }
  it { expect(subject).to have_many(:invitations) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:yammer_user_id) }
  it { expect(subject).to allow_value(nil).for(:encrypted_access_token) }

  it 'is valid with a unique encrypted access token' do
    user = create(:user)

    expect(user).to validate_uniqueness_of(:encrypted_access_token)
  end

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

  context 'encrypted_access_token' do
    it 'encrypts access_token before validation on create' do
      access_token = 'abc123'
      expected_encrypted_access_token =
        Encryptor.encrypt(access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY'])
      expected_encrypted_access_token =
        Base64.encode64(expected_encrypted_access_token)
      user = build(:user, access_token: access_token)

      user.save
      expect(user.encrypted_access_token).to eq expected_encrypted_access_token
    end
  end
end

describe User, 'has_attached_file' do
  it { expect(subject).to have_attached_file(:watermarked_image) }
end

describe User, '#usurp_existing_guest_accounts' do
  it 'associates all guest invitations with this user' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    guest_invitation_ids = guest.invitations.map(&:id)
    user = create(:user, email: guest.email)

    user.usurp_existing_guest_accounts

    expect(user.invitations.map(&:id)).to eq guest_invitation_ids
  end

  it 'deletes the guest which we found' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    user = create(:user, email: guest.email)

    user.usurp_existing_guest_accounts

    guest_check = Guest.find_by_email(guest.email)
    expect(guest_check).to be_nil
  end
end

describe User, '#in_network?' do
  it 'returns true if user is in network' do
    user = build_stubbed(:user, yammer_network_id: 1)
    in_network_user = build_stubbed(:user, yammer_network_id: 1)

    expect(user).to be_in_network(in_network_user)
  end

  it 'returns false if user is out network' do
    user = build_stubbed(:user, yammer_network_id: 1)
    in_network_user = build_stubbed(:user, yammer_network_id: 2)

    expect(user).to_not be_in_network(in_network_user)
  end
end

describe User, '#able_to_edit?' do
  it 'returns true if the user created the event' do
    event = create(:event)
    user = event.owner
    expect(event.owner).to be_able_to_edit(event)
  end

  it 'returns false if the user did not create the event' do
    event = create(:event)
    expect(build(:user)).to_not be_able_to_edit(event)
  end
end

describe User, '#image' do
  it 'returns the placeholder if there is no image' do
    user = build_stubbed(:user, image: nil)

    expect(user.image).to eq 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  it 'returns the absolute image url if one exists' do
    user = create(:user)
    expect(user.image).to include('https://mug0.assets-yammer.com/')
  end
end

describe User, '#votes' do
  it 'returns the users votes if there are any' do
    user = create(:user)
    vote = create(:vote, voter: user)
    expect(user.votes).to eq [vote]
  end

  it 'returns an empty array if the user has no votes' do
    user = build(:user)
    expect(user.votes).to eq []
  end
end

describe User, '#vote_for_suggestion' do
  it 'returns the users vote for the given suggestion if the user has one' do
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

describe User, '#voted_for_suggestion?' do
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
  it 'returns true if the user voted for the event' do
    user = create(:user)
    vote = create(:vote, voter: user)
    expect(user.voted_for_event?(vote.event)).to be_true
  end

  it 'returns false if the user did not vote for the event' do
    user = create(:user)
    event = create(:event)

    expect(user.voted_for_event?(event)).to be_false
  end
end

describe User, '#yammer_user?' do
  it 'always returns true' do
    expect(build(:user)).to be_yammer_user
  end
end

describe User, '#invite' do
  include DelayedJobSpecHelper

  it 'if the user is out-network, it sends an email notification' do
    invitee = create(:out_network_user)
    invitation = build(:invitation_with_user, invitee: invitee)
    messenger_instance = mock('messenger instance', :invite)
    Messenger.expects(:new).
      with(invitation, invitation.sender).
      returns(messenger_instance)

    organizer = invitation.sender
    event = invitation.event

    invitee.invite(invitation)
    work_off_delayed_jobs

    expect(organizer).to_not be_in_network(invitee)
    expect(messenger_instance).to have_received(:invite)
  end

  it 'sends a private message notification, if the user is in-network' do
    invitee = build_stubbed(:user)
    invitation = build_stubbed(:invitation_with_user, invitee: invitee)
    organizer = invitation.sender
    owner = invitation.event.owner

    invitee.remind(invitation, owner)
    work_off_delayed_jobs

    expect(organizer).to be_in_network(invitee)
    expect(FakeYammer.messages_endpoint_hits).to eq 1
    expect(FakeYammer.message).to include(invitation.event.name)
  end
end

describe User, '#remind' do
  include DelayedJobSpecHelper

  it 'hits the Yammer messages API, if the user is in-network' do
    invitee = build_stubbed(:user)
    invitation = build_stubbed(:invitation_with_user,
                               invitee: invitee)

    expect {
      invitee.remind(invitation, invitation.sender)
      work_off_delayed_jobs
    }.to change(FakeYammer, :messages_endpoint_hits).by(1)
  end
end

describe User, '#update_watermark' do
  it 'does not update the watermark for users without an existing watermark' do
    user = build(:user, watermarked_image: nil)

    user.update_watermark

    expect(user.watermarked_image.url).to eq (
      '/watermarked_images/original/missing.png'
    )
  end
end

describe User, '#watermark' do
  it 'returns a URL string pointing to the event owner profile photo' do
    user = build(:user)

    expect(user.watermark).to eq user.image
  end
end
