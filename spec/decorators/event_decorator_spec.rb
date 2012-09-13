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
