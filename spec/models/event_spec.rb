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

  it 'should allow the event to have one or more suggestions' do
    event = create(:event)

    event.should be_valid
  end

  it 'should not allow the event to have no suggestions' do
    event = create(:event)
    event.suggestions.destroy_all

    event.should be_invalid
  end

  it 'has a uuid after creation' do
    event = create(:event)
    event.uuid.length.should eq(8)
  end

 it 'runs #set_first_suggestion on validate' do
    event = build(:event)
    Event.any_instance.stubs(:set_first_suggestion)

    event.valid?

    Event.any_instance.should have_received(:set_first_suggestion)
  end
end

describe Event, '#build_suggestions' do
  it 'builds 2 suggestions' do
    event = build(:event)
    event.build_suggestions

    event.suggestions.length.should == 2
    event.suggestions.each do |suggestion|
      suggestion.should be_a Suggestion
    end
  end

  it 'does not replace suggestions if they were already set' do
    event = build(:event)
    first_suggestion = Suggestion.new
    second_suggestion = Suggestion.new
    event.suggestions = [first_suggestion, second_suggestion]

    event.build_suggestions

    event.suggestions[0].should == first_suggestion
    event.suggestions[1].should == second_suggestion
  end

  it 'adds the owner as the first invitee upon event creation' do
    event = create(:event)

    event.invitees.first.should == event.owner
  end
end

describe Event, '#add_errors_if_no_suggestions' do
  it 'adds errors if an event has no suggestions' do
    event = create(:event)
    event.suggestions.destroy_all

    event.add_errors_if_no_suggestions
    error = event.errors.messages[:suggestions].first

    error.should == 'An event must have at least one suggestion'
  end

  it 'adds errors if an event has suggestions marked_for_destruction' do
    event = create(:event)
    event.suggestions.map(&:mark_for_destruction)

    event.add_errors_if_no_suggestions
    error = event.errors.messages[:suggestions].first

    error.should == 'An event must have at least one suggestion'
  end

  it 'adds no errors if an event has suggestions' do
    event = create(:event)

    event.add_errors_if_no_suggestions
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

describe Event, '#user_voted?' do
  it 'returns true if the user has voted on the event' do
    event = create(:event)
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(:vote, voter: user, suggestion: suggestion)

    event.user_voted?(user).should be_true
  end

  it 'returns false if the user has not voted on the event' do
    event = create(:event)
    user = event.owner
    suggestion = create(:suggestion, event: event)

    event.user_voted?(user).should be_false
  end
end

describe Event, '#user_owner?' do
  it 'returns true if the user is the owner of the event' do
    event = create(:event)
    user = event.owner

    event.should be_user_owner(user)
  end

  it 'returns false if the user is not the owner of the event' do
    event = create(:event)

    event.should_not be_user_owner(build(:user))
  end
end

describe Event, '#user_votes' do
  it 'does not return an event\'s votes for a user unless they voted' do
    event = create(:event)
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(:vote, suggestion: suggestion)

    event.user_votes(user).should_not include(vote)
  end

  it 'returns an events votes for a specific user if they voted' do
    event = create(:event)
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(:vote, voter: user, suggestion: suggestion)

    event.user_votes(user).should include(vote)
  end
end

describe Event, '#set_first_suggestion' do
  it 'sets the first suggestion if it is blank' do
    event = build(:event)
    event.suggestions[0] = nil

    event.set_first_suggestion

    event.suggestions[0].should be_a Suggestion
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

describe Event, '#invitation_for' do
  it 'returns the invitation for this user' do
    invitation = create(:invitation)
    invitee = invitation.invitee
    event = invitation.event

    event.invitation_for(invitee).should == invitation
  end
end

describe Event, '#deliver_reminder_from' do
  it 'sends a reminder to invited users, but not to the sender' do
    sender = create(:user)
    guest = create(:guest)
    user = create(:user)
    sender = build_stubbed(:user)
    event = create_event_with_invitees(guest, user)
    Invitation.any_instance.stubs(sender: sender)

    event.deliver_reminder_from(sender)

    guest.should have_received(:deliver_email_or_private_message).once
    user.should have_received(:deliver_email_or_private_message).once
    sender.should have_received(:deliver_email_or_private_message).never
  end
end

def create_event_with_invitees(guest, user)
  event = create(:event)

  guest.stubs(:deliver_email_or_private_message)
  user.stubs(:deliver_email_or_private_message)

  event.users << user
  event.guests << guest

  event
end
