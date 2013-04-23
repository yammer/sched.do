require 'spec_helper'

describe Invitation do
  it { expect(subject).to allow_mass_assignment_of(:event) }
  it { expect(subject).to allow_mass_assignment_of(:invitee) }
  it { expect(subject).to allow_mass_assignment_of(:sender) }

  it { expect(subject).to belong_to(:event) }
  it { expect(subject).to belong_to(:invitee) }
  it { expect(subject).to belong_to(:sender) }

  it { expect(subject).to accept_nested_attributes_for :invitee }

  it { expect(subject).to validate_presence_of(:event_id) }
  it { expect(subject).to validate_presence_of(:invitee_type) }
  it { expect(subject).to validate_presence_of(:invitee_id).with_message(/is invalid/) }

  it 'is valid if the event owner is not invited' do
    user = build_stubbed(:user)

    invitation = build_stubbed(:invitation, invitee: user)

    expect(invitation).to be_valid
  end

  it 'is invalid if the invitee was already invited' do
    event = build_stubbed(:event)
    invitee = create(:user)

    first_invitation = create(:invitation, event: event, invitee: invitee)
    second_invitation = build_stubbed(
      :invitation, event: event, invitee: invitee
    )

    expect(second_invitation).to be_invalid
  end
end

describe Invitation, '#invite' do
  context 'when the invite is valid' do
    it 'notifies the invitee with a message' do
      invitee = create(:user)
      sender = build_stubbed(:user)
      event = build_stubbed(:event)
      InvitationCreatedMessageJob.stubs(:enqueue)
      invitation = Invitation.new(event: event, invitee: invitee, sender: sender)

      invitation.invite

      expect(InvitationCreatedMessageJob).to have_received(:enqueue)
    end
  end

  context 'when the invite is invalid' do
    it 'does not notify the invitee with a message' do
      InvitationCreatedMessageJob.stubs(:enqueue)
      invitation = Invitation.new

      invitation.invite

      expect(InvitationCreatedMessageJob).to have_received(:enqueue).never
    end
  end

  context 'when the sender is a yammer user' do
    it 'creates an activity message for the sending user' do
      invitee = create(:user)
      sender = build_stubbed(:user)
      event = build_stubbed(:event)
      ActivityCreatorJob.stubs(:enqueue)
      invitation = Invitation.new(event: event, invitee: invitee, sender: sender)
      invitation.invite

      expect(ActivityCreatorJob).to have_received(:enqueue).
        with(sender, 'share', event)
    end
  end

  context 'when the sender is not a yammer user' do
    it 'does not create an activity message for the sending user' do
      invitee = create(:user)
      sender = build_stubbed(:guest)
      event = build_stubbed(:event)
      ActivityCreatorJob.stubs(:enqueue)
      invitation = Invitation.new(event: event, invitee: invitee, sender: sender)
      invitation.invite

      expect(ActivityCreatorJob).to have_received(:enqueue).never
    end
  end
end

describe Invitation, '#invite_without_notification' do
  it 'does not notify the invitee' do
    user = create(:user)
    event = create(:event)
    InvitationCreatedMessageJob.stubs(:enqueue)
    invitation = Invitation.new(event: event, invitee: user)

    invitation.invite_without_notification

    expect(InvitationCreatedMessageJob).to have_received(:enqueue).never
  end
end

describe Invitation, '#deliver_reminder_from' do
  it 'sends a reminder to the invitee and set the reminded_at' do
    Timecop.freeze do
      invitation = create(:invitation)
      invitee = invitation.invitee
      invitee.stubs(:remind)
      sender = create(:user)

      invitation.deliver_reminder_from(sender)

      expect(invitee).to have_received(:remind).once
      expect(invitation.reminded_at).to eq Time.now
    end
  end
end

describe Invitation, '.deliver_automatic_reminders' do
  it 'sends reminders to invitations over five days' do
    invitations = [
      create(:invitation, created_at: 6.days.ago),
      create(:invitation, created_at: 6.days.ago)
    ]
    message = stub('message', deliver: true)
    UserMailer.stubs(:reminder).returns(message)

    Invitation.deliver_automatic_reminders

    invitations.each do |invitation|
      expect(UserMailer).to have_received(:reminder).
        with(invitation.invitee, invitation.sender, invitation.event)
    end
    expect(message).to have_received(:deliver).at_least_once
  end

  it 'does not send an automatic reminder to the event creator' do
    invitation = create(:invitation, sender: nil, created_at: 6.days.ago)
    message = stub('message', deliver: true)
    UserMailer.stubs(:reminder).returns(message)

    Invitation.deliver_automatic_reminders

    expect(message).to have_received(:deliver).never
  end

  it 'does not send an automatic reminder before the invitation is five days old' do
    Timecop.freeze do
      invitation = create(:invitation, created_at: Time.now)
      message = stub('message', delive: true)
      UserMailer.stubs(:reminder).returns(message)

      Invitation.deliver_automatic_reminders

      expect(message).to have_received(:deliver).never
    end
  end

  it 'does not send an automatic reminder when the invitee has voted' do
    vote = create(:vote)
    invitation = create(:invitation, created_at: 6.days.ago, vote: vote)
    message = stub('message', deliver: true)
    UserMailer.stubs(:reminder).returns(message)

    Invitation.deliver_automatic_reminders

    expect(message).to have_received(:deliver).never
  end

  it 'does not send an automatic reminder when the invitee has already been reminded' do
    invitation = create(
      :invitation,
      created_at: 6.days.ago,
      reminded_at: 1.day.ago
    )
    message = stub('message', deliver: true)
    UserMailer.stubs(:reminder).returns(message)

    Invitation.deliver_automatic_reminders

    expect(message).to have_received(:deliver).never
  end

  it 'does not send automatic reminders to groups' do
    group = create(:group)
    invitation = create(
      :invitation,
      created_at: 6.days.ago,
      invitee: group
    )
    message = stub('message', deliver: true)
    UserMailer.stubs(:reminder).returns(message)

    Invitation.deliver_automatic_reminders

    expect(message).to have_received(:deliver).never
  end

  it 'sets reminded_at on the invitation'do
    Timecop.freeze do
      invitation = create(:invitation, created_at: 6.days.ago, reminded_at: nil)
      message = stub('message', deliver: true)
      UserMailer.stubs(:reminder).returns(message)

      Invitation.deliver_automatic_reminders

      expect(invitation.reload.reminded_at).to be_within(1).of(Time.now)
    end
  end
end

describe Invitation, '#deletable_by?' do
  context 'when event is closed' do
    it 'returns false' do
      invitation = build(:invitation)

      expect(invitation).to be_deletable_by(invitation.invitee)
    end
  end

  context 'when invitee is the owner' do
    it 'returns false' do
      invitation = build(:invitation)
      invitation.invitee = invitation.event.owner

      expect(invitation).not_to be_deletable_by(invitation.event.owner)
    end
  end

  context 'when remover is the owner' do
    it 'returns true' do
      invitation = build(:invitation)

      expect(invitation).to be_deletable_by(invitation.event.owner)
    end
  end

  context 'when invitee is a user' do
    it 'returns true' do
      invitation = build(:invitation)

      expect(invitation).to be_deletable_by(invitation.invitee)
    end
  end

  context 'when invitee is a guest' do
    it 'returns true' do
      invitation = build(:invitation_with_guest)

      expect(invitation).to be_deletable_by(invitation.invitee)
    end
  end
end
