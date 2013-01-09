require 'spec_helper'

describe EventDecorator, '#invitees_with_current_user_first' do
  it 'creates an array of invitees, with the current user first' do
    event = event_with_invitees
    unsorted_invitees = event.invitees
    current_user = unsorted_invitees.second
    EventDecorator.any_instance.stubs(current_user: current_user)

    sorted_invitees = EventDecorator.new(event).invitees_with_current_user_first

    sorted_invitees.first.should == current_user
    sorted_invitees.should_not == unsorted_invitees
    sorted_invitees.select { |user| user == current_user }.length.should == 1
  end

  it 'includes the event creator' do
    event = event_with_invitees
    event_creator = event.owner

    sorted_invitees = EventDecorator.new(event).invitees_with_current_user_first

    sorted_invitees.should include(event_creator)
  end
end

describe EventDecorator, '#other_invitees_who_have_not_voted_count' do
  it 'returns the number of other invitees who have not voted' do
    event = EventDecorator.new(event_with_invitees)
    invitees = event.invitees
    suggestion = event.suggestions.first
    EventDecorator.any_instance.stubs(current_user: event.owner)
    vote = create(:vote, voter: invitees.first, suggestion: suggestion)

    invitees_count = event.other_invitees_who_have_not_voted_count

    invitees_count.should == 1
    invitees.count.should == 3
  end
end

describe EventDecorator, '#first_invitee_for_invitation' do
  context 'when an event has invitees' do
    it 'returns the first invitee with a name' do
      event = event_with_invitees
      guest = event.invitees.first
      guest.name = nil
      user = event.invitees.second

      string = EventDecorator.new(event).first_invitee_for_invitation

      string.should == ", #{user.name}, "
    end

    it 'returns the first invitee if one exists' do
      event = event_with_invitees
      first_invitee = event.invitees.first

      string = EventDecorator.new(event).first_invitee_for_invitation

      string.should == ", #{first_invitee.name}, "
    end
  end

  context 'when an event has no invitees' do
    it 'returns a space if no invitees' do
      event = build_stubbed(:event)
      event.invitees.should be_empty

      string = EventDecorator.new(event).first_invitee_for_invitation

      string.should == ' '
    end
  end
end

def event_with_invitees
  event = create(:event)
  invitation = create(:invitation_with_user, event: event)
  invitation = create(:invitation_with_guest, event: event)
  event
end
