require 'spec_helper'

describe Event, 'accessors' do
  it { expect(subject).to allow_mass_assignment_of(:name) }
  it { expect(subject).to allow_mass_assignment_of(:primary_suggestions_attributes) }
  it { expect(subject).to allow_mass_assignment_of(:uuid) }
end

describe Event, 'associations' do
  it { expect(subject).to belong_to(:owner).class_name('User') }
end

describe Event, 'Suggestion associations' do
  it { expect(subject).to have_many(:primary_suggestions) }
  it { expect(subject).to have_many(:votes) }
end

describe Event, 'Invitation associations' do
  it { expect(subject).to have_many(:invitations) }
  it { expect(subject).to have_many(:users).through(:invitations) }
  it { expect(subject).to have_many(:guests).through(:invitations) }
  it { expect(subject).to have_many(:groups).through(:invitations) }
end

describe Event, 'accepts_nested_attributes_for' do
  it { expect(subject).to accept_nested_attributes_for(:primary_suggestions).
    allow_destroy(true) }
end

describe Event, 'before_validation' do
  it 'generates an 8 character uuid' do
    event = build(:event, uuid: '')

    event.valid?

    expect(event.uuid.length).to eq 8
  end

  it 'sets the first suggestion' do
    event = build(:event)

    event.valid?

    expect(event.suggestions[0]).to be_present
  end
end

describe Event, 'before_create' do
  context 'when event has a time based suggestion' do
    it 'sets time_based to true' do
      suggestion = build(:suggestion, description: 'Monday')
      event = build(:event, primary_suggestions: [suggestion])

      event.save

      expect(event).to be_time_based
    end
  end

  context 'when event does not have all time based suggestions' do
    it 'sets time_based to false' do
      suggestion1 = build(:suggestion, description: 'March 31')
      suggestion2 = build(:suggestion, description: 'Bananas')
      event = build(:event, primary_suggestions: [suggestion1, suggestion2])

      event.save

      expect(event).not_to be_time_based
    end
  end
end

describe Event, 'validations' do
  it { expect(subject).to validate_presence_of(:name).with_message(/field is required/) }
  it { expect(subject).to ensure_length_of(:name).is_at_most(Event::NAME_MAX_LENGTH) }
  it { expect(subject).to validate_presence_of(:user_id) }
  it { expect(subject).to have_db_column(:open).of_type(:boolean) }

  it 'validates presence of a uuid' do
    event = create(:event)
    event.uuid = nil

    expect(event).to_not be_valid
  end

  it 'sets the default open value to true' do
    event = build(:event)

    expect(event.open?).to be_true
  end
end

describe Event, 'add_errors_if_no_suggestions' do
  it 'adds errors if there are no primary suggestions' do
    event = create(:event)
    event.suggestions.map(&:mark_for_destruction)

    event.valid?

    error = event.errors.messages[:primary_suggestions].first
    expect(error).to eq 'An event must have at least one suggestion'
  end

  it 'requires an event to have primary suggestions' do
    event = build(:event)
    event.primary_suggestions.clear

    expect(event).to be_invalid
  end
end

describe Event, 'after_create callbacks' do
  it 'invites the owner' do
    owner = create(:user)
    event = create(:event, owner: owner)

    expect(event.invitees).to include(owner)
  end

  context '#enqueue_event_created_job' do
    it 'enqueues an EventCreatedEmailJob' do
      EventCreatedEmailJob.stub(:enqueue)

      event = create(:event)

      expect(EventCreatedEmailJob).to have_received(:enqueue).with(event)
    end

    it 'enqueues a ActivityCreatorJob' do
      ActivityCreatorJob.stub(:enqueue)
      action = 'create'

      event = create(:event)

      user = event.owner
      expect(ActivityCreatorJob).to have_received(:enqueue).with(user, action, event)
    end
  end
end

describe Event, 'after_update callbacks' do
  it 'enqueues an ActivityCreatorJob' do
    ActivityCreatorJob.stub(:enqueue)
    action = 'update'
    event = create(:event, name: 'event')
    user = event.owner

    event.update_attributes(name: 'updated event')

    expect(ActivityCreatorJob).to have_received(:enqueue).with(user, action, event)
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
    event.stub(invitations_without: user_invitations)
    user_invitation.stub(:deliver_reminder_from)

    event.deliver_reminder_from(sender)

    expect(user_invitation).to have_received(:deliver_reminder_from).with(sender)
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

    expect(event.invitees).to match_array invitees
  end

  it 'returns invitees with the newest first' do
    event = create(:event)
    first_invitee = create(:invitation_with_user, event: event).invitee
    second_invitee = create(:invitation_with_user, event: event).invitee

    event.reload

    expect(event.invitees).to eq [second_invitee, first_invitee, event.owner]
  end
end

describe Event, '#to_param' do
  it 'returns the uuid for use in monkeypatching the to_param path helper' do
    event = build(:event)

    output = event.to_param

    expect(output).to eq event.uuid
  end
end

describe Event, '#suggestions' do
  it 'returns sorted primary suggestions' do
    event = build(:event)
    suggestion1 = build(:primary_suggestion, description: "Apr 12, 2016")
    suggestion2 = build(:primary_suggestion, description: "Apr 12, 2015")
    event.primary_suggestions = [suggestion1, suggestion2]

    expect(event.suggestions).to eq [suggestion2, suggestion1]
  end
end

describe Event, '#editable_by?' do
  context 'with creator' do
    it 'returns true' do
      event = build(:event)

      expect(event).to be_editable_by(event.owner)
    end

    context 'with closed event' do
      it 'returns false' do
        event = build(:closed_event)

        expect(event).not_to be_editable_by(event.owner)
      end
    end
  end

  context 'with invitee' do
    it 'returns false' do
      invitation = build(:invitation_with_user)
      event = invitation.event
      invitee = invitation.invitee

      expect(event).not_to be_editable_by(invitee)
    end
  end

  context 'with guest' do
    it 'returns false' do
      invitation = build(:invitation_with_guest)
      event = invitation.event
      guest = invitation.invitee

      expect(event).not_to be_editable_by(guest)
    end
  end
end

