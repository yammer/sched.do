require 'spec_helper'

describe Invitation do
  it { should belong_to(:event) }
  it { should belong_to(:invitee) }
  it { should belong_to(:sender) }

  it { should accept_nested_attributes_for :invitee }

  it { should allow_mass_assignment_of(:event) }
  it { should allow_mass_assignment_of(:invitee) }

  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:invitee_id).with_message(/is invalid/) }
  it { should validate_presence_of(:invitee_type) }

  it 'is valid if the event owner is not invited' do
    user = create(:user)
    invitation = build_stubbed(:invitation, invitee: user)

    invitation.should be_valid
  end

  it 'is invalid if the invitee was already invited' do
    event = create(:event)
    user = create(:user)

    first_invitation = create(:invitation, event: event, invitee: user)
    second_invitation = build_stubbed(:invitation, event: event, invitee: user)

    second_invitation.should be_invalid
  end
end

describe Invitation, '#create' do
  it 'creates a delayed job' do
    InvitationCreatedJob.stubs(:enqueue)
  end

  it 'invite_without_notification does not notify the invitee' do
    user = create(:user)
    event = create(:event)
    user.stubs(:invite)

    Invitation.invite_without_notification(event, user)

    user.should have_received(:invite).never
  end
end


describe Invitation, '#deliver_reminder_from' do
  it 'sends a reminder to the invitee' do
    invitation = create(:invitation)
    invitee = invitation.invitee
    invitee.stubs(:remind)
    sender = create(:user)

    invitation.deliver_reminder_from(sender)

    invitee.should have_received(:remind).once
  end
end
