require 'spec_helper'

describe EventDecorator, '#invitees_with_current_user_first' do
  it 'creates an array of invitees, with the current user first' do
    event = build_stubbed(:event_with_invitees)
    unsorted_invitees = event.invitees
    current_user = unsorted_invitees.second
    EventDecorator.any_instance.stubs(current_user: current_user)

    sorted_invitees = EventDecorator.new(event).invitees_with_current_user_first

    sorted_invitees.first.should == current_user
    sorted_invitees.should_not == unsorted_invitees
    sorted_invitees.select { |user| user == current_user }.length.should == 1
  end

  it 'includes the event creator' do
    event = build_stubbed(:event_with_invitees)
    event_creator = event.user

    sorted_invitees = EventDecorator.new(event).invitees_with_current_user_first

    sorted_invitees.should include(event_creator)
  end
end

describe EventDecorator, '#invitees_who_have_not_voted_count' do
  it 'returns the number of invitees who have not voted' do
    event = create(:event)
    decorated_event = EventDecorator.new(event)
    invitees = create_list(:invitation_with_user, 2, event: event).
      map(&:invitee)
    suggestion = create(:suggestion, event: event)
    vote = create(:vote, voter: invitees.last, suggestion: suggestion)

    decorated_event.invitees_who_have_not_voted_count.should == 2
  end
end

describe EventDecorator, '#first_invitee_for_invitation' do
  it 'returns a space if no invitees' do
    event = build_stubbed(:event)

    string = EventDecorator.new(event).first_invitee_for_invitation

    string.should == ' '
  end

  it 'returns the first invitee with a name' do
    event = create(:event_with_invitees)
    guest = event.invitees.first
    guest.name = nil
    user = event.invitees.second

    string = EventDecorator.new(event).first_invitee_for_invitation

    string.should == ", #{user.name}, "
  end

  it 'returns the first invitee if one exists' do
    event = create(:event_with_invitees)
    first_invitee = event.invitees.first

    string = EventDecorator.new(event).first_invitee_for_invitation

    string.should == ", #{first_invitee.name}, "
  end
end
