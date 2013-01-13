require 'spec_helper'

describe Event do
  include DelayedJobSpecHelper

  NAME_MAX_LENGTH = Event::NAME_MAX_LENGTH

  it { should belong_to(:owner) }
  it { should have_many(:suggestions) }
  it { should have_many(:votes).through(:suggestions) }
  it { should have_many(:invitations) }
  it { should have_many(:users).through(:invitations) }
  it { should have_many(:guests).through(:invitations) }
  it { should have_many(:groups).through(:invitations) }

  it { should validate_presence_of(:name).
       with_message(/This field is required/) }
  it { should validate_presence_of(:user_id) }
  it { should ensure_length_of(:name).is_at_most(NAME_MAX_LENGTH) }

  it { should allow_mass_assignment_of(:suggestion) }
  it { should allow_mass_assignment_of(:suggestions_attributes) }

  it { should accept_nested_attributes_for(:suggestions).allow_destroy(true) }

  it 'allows the event to have one or more suggestions' do
    event = create(:event)

    event.should be_valid
  end

  it 'requires an event to have suggestions' do
    event = create(:event)
    event.suggestions.destroy_all

    event.should be_invalid
  end

  it 'generates an 8 character uuid' do
    event = create(:event)
    event.uuid.length.should eq(8)
  end

 it 'runs #set_first_suggestion on validate' do
    event = build(:event)
    Event.any_instance.stubs(:set_first_suggestion)

    event.valid?

    Event.any_instance.should have_received(:set_first_suggestion)
  end

  it 'sets the first suggestion if it is blank' do
    event = build(:event)
    event.suggestions[0] = nil

    event.valid?

    event.suggestions[0].should be_a Suggestion
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

describe Event, '#add_errors_if_no_suggestions' do
  it 'adds errors if an event has suggestions marked_for_destruction' do
    event = create(:event)
    event.suggestions.map(&:mark_for_destruction)

    event.valid?
    error = event.errors.messages[:suggestions].first

    error.should == 'An event must have at least one suggestion'
  end

  it 'adds no errors if an event has suggestions' do
    event = create(:event)

    error = event.errors.messages

    error.should be_empty
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

describe Event, '#enqueue_event_created_job' do
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

describe Event, '#to_param' do
  it 'returns the uuid for use in monkeypatching the to_param path helper' do
    event = build(:event)

    output = event.to_param

    output.should == event.uuid
  end
end
