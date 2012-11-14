require 'spec_helper'

describe EventDecorator, '#other_invitees_count' do
  it 'returns 0 if no one has been invited' do
    event = create(:event)
    decorated_event = EventDecorator.new(event)

    count = decorated_event.other_invitees_count

    count.should == 0
  end

  it 'returns 2 if 2 other people have been invited' do
    event = create(:event_with_invitees)
    decorated_event = EventDecorator.new(event)

    count = decorated_event.other_invitees_count

    count.should == 2
  end
end

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
    event = create(:event_with_invitees)
    event_creator = event.owner

    sorted_invitees = EventDecorator.new(event).invitees_with_current_user_first

    sorted_invitees.should include(event_creator)
  end
end

describe EventDecorator, '#invitees_who_have_not_voted_count' do
  it 'returns the number of invitees who have not voted' do
    event = create(:event_with_invitees)
    invitees = event.invitees
    suggestion = event.suggestions.first
    EventDecorator.any_instance.stubs(current_user: event.owner)
    decorated_event = EventDecorator.new(event)
    vote = create(:vote, voter: invitees.first, suggestion: suggestion)

    invitees_count = decorated_event.other_invitees_who_have_not_voted_count

    invitees_count.should == 1
  end
end

describe EventDecorator, '#first_invitee_for_invitation' do
  context 'when an event has invitees' do
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

  context 'when an event has no invitees' do
    it 'returns a space if no invitees' do
      event = build_stubbed(:event)
      event.invitees.should be_empty

      string = EventDecorator.new(event).first_invitee_for_invitation

      string.should == ' '
    end
  end
end
