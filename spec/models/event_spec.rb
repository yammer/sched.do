require 'spec_helper'

describe Event, 'accessors' do
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:primary_suggestions_attributes) }
  it { should allow_mass_assignment_of(:uuid) }
end

describe Event, 'associations' do
  it { should belong_to(:owner).class_name('User') }
end

describe Event, 'Suggestion associations' do
  it { should have_many(:primary_suggestions) }
  it { should have_many(:votes) }
end

describe Event, 'Invitation associations' do
  it { should have_many(:invitations) }
  it { should have_many(:users).through(:invitations) }
  it { should have_many(:guests).through(:invitations) }
  it { should have_many(:groups).through(:invitations) }
end

describe Event, 'accepts_nested_attributes_for' do
  it { should accept_nested_attributes_for(:primary_suggestions).
    allow_destroy(true) }
end

describe Event, 'before_validation' do
  it 'generates an 8 character uuid' do
    event = build(:event, uuid: '')

    event.valid?

    event.uuid.length.should == 8
  end

  it 'sets the first suggestion' do
    event = build(:event)

    event.valid?

    event.suggestions[0].should be_present
  end
end

describe Event, 'validations'do
  it { should validate_presence_of(:name).with_message(/field is required/) }
  it { should ensure_length_of(:name).is_at_most(Event::NAME_MAX_LENGTH) }
  it { should validate_presence_of(:user_id) }

  it 'validates presence of a uuid' do
    event = create(:event)
    event.uuid = nil

    event.should_not be_valid
  end
end

describe Event, 'add_errors_if_no_suggestions'do
  it 'adds errors if there are no primary suggestions' do
    event = create(:event)
    event.suggestions.map(&:mark_for_destruction)

    event.valid?

    error = event.errors.messages[:primary_suggestions].first
    error.should == 'An event must have at least one suggestion'
  end

  it 'requires an event to have primary suggestions' do
    event = create(:event)
    event.suggestions.destroy_all

    event.should be_invalid
  end
end

describe Event, 'after_create callbacks'do
  it 'invites the owner' do
    owner = create(:user)
    event = create(:event, owner: owner)

    event.invitees.should include(owner)
  end

  context '#enqueue_event_created_job' do
    it 'enqueues an EventCreatedEmailJob' do
      EventCreatedEmailJob.stubs(:enqueue)

      event = create(:event)

      EventCreatedEmailJob.should have_received(:enqueue).with(event)
    end

    it 'enqueues a ActivityCreatorJob' do
      ActivityCreatorJob.stubs(:enqueue)
      action = 'create'

      event = create(:event)

      user = event.owner
      ActivityCreatorJob.should have_received(:enqueue).with(user, action, event)
    end
  end
end

describe Event, '#deliver_reminder_from' do
  it 'sends a reminder to invited users, but not to the sender' do
    event = create(:event)
    sender_invitation = event.invitations.first
    sender = sender_invitation.invitee
    user = create(:user)
    user_invitation = create(:invitation, event: event, invitee: user)
    user_invitations = [user_invitation]
    event.stubs(:invitations_without).returns(user_invitations)
    user_invitation.stubs(:deliver_reminder_from)

    event.deliver_reminder_from(sender)

    user_invitation.should have_received(:deliver_reminder_from).with(sender)
  end
end

describe Event, '#invitees' do
  it 'returns the users and guests invited to an event' do
    event = create(:event)
    invitees = [ event.owner ]
    invitees += create_list(:invitation_with_user, 2, event: event).
      map(&:invitee)
    invitees += create_list(:invitation_with_guest, 2, event: event).
      map(&:invitee)

    event.reload

    event.invitees.should =~ invitees
  end

  it 'returns invitees with the newest first' do
    event = create(:event)
    first_invitee = create(:invitation_with_user, event: event).invitee
    second_invitee = create(:invitation_with_user, event: event).invitee

    event.reload

    event.invitees.should == [second_invitee, first_invitee, event.owner]
  end
end

describe Event, '#to_param' do
  it 'returns the uuid for use in monkeypatching the to_param path helper' do
    event = build(:event)

    output = event.to_param

    output.should == event.uuid
  end
end

describe Event, '#suggestions' do
  it 'returns the primary suggestions' do
    event = build(:event)

    event.primary_suggestions.should == event.suggestions
  end
end
