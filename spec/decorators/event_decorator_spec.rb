require 'spec_helper'

describe EventDecorator, '#build_suggestions' do
  it 'builds 2 suggestions' do
    event = EventDecorator.new(build(:event))

    event.build_suggestions

    event.suggestions.length.should == 2
    event.suggestions.each do |suggestion| 
      suggestion.should be_a(PrimarySuggestion)
      suggestion.secondary_suggestions.each do |secondary|
        secondary.should be_a(SecondarySuggestion)
      end
    end
  end

  it 'does not replace suggestions if they were already set' do
    event = EventDecorator.new(build(:event))
    first_suggestion = PrimarySuggestion.new
    second_suggestion = PrimarySuggestion.new
    secondary_suggestion = SecondarySuggestion.new
    second_suggestion.secondary_suggestions = [secondary_suggestion]
    event.primary_suggestions = [first_suggestion, second_suggestion]

    event.build_suggestions

    event.suggestions[0].should == first_suggestion
    event.suggestions[1].should == second_suggestion
    event.suggestions[1].secondary_suggestions[0].should == secondary_suggestion
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

describe EventDecorator, '#invitation_for' do
  it 'returns the invitation for this user' do
    invitation = create(:invitation)
    invitee = invitation.invitee
    event = EventDecorator.new(invitation.event)

    invitation_for = event.invitation_for(invitee)

    invitation_for.should == invitation
  end
end

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
    vote = create(
      :vote, 
      event: event, 
      voter: invitees.first, 
      suggestion: suggestion
    )

    invitees_count = event.other_invitees_who_have_not_voted_count

    invitees_count.should == 1
    invitees.count.should == 3
  end
end

describe EventDecorator, '#user_not_invited?' do
  it 'returns true if the user is not invited' do
    event = EventDecorator.new(event_with_invitees)
    outside_user = build_stubbed(:user)

    event.user_not_invited?(outside_user).should == true
  end

  it 'returns false if the user is invited' do
    event = EventDecorator.new(event_with_invitees)
    owner = event.owner

    event.user_not_invited?(owner).should == false
  end
end

describe EventDecorator, '#user_owner?' do
  it 'returns true if the user is the owner of the event' do
    event = EventDecorator.new(create(:event))
    owner = event.owner

    event.should be_user_owner(owner)
  end

  it 'returns false if the user is not the owner of the event' do
    event = EventDecorator.new(create(:event))
    another_invitee = event.invitees.find { |i| i != event.owner }

    event.should_not be_user_owner(another_invitee)
  end
end

describe EventDecorator, '#user_voted?' do
  it 'returns true if the user has voted on the event' do
    event = EventDecorator.new(create(:event))
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(
      :vote, 
      event: event,
      voter: user, 
      suggestion: suggestion
    )

    event.user_voted?(user).should be_true
  end

  it 'returns false if the user has not voted on the event' do
    event = EventDecorator.new(create(:event))
    user = event.owner
    suggestion = create(:suggestion, event: event)

    event.user_voted?(user).should be_false
  end
end

describe EventDecorator, '#user_votes' do
  it 'returns an events votes for a specific user if they voted' do
    event = EventDecorator.new(create(:event))
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(
      :vote, 
      event: event,
      voter: user, 
      suggestion: suggestion
    )

    user_votes = event.user_votes(user)

    user_votes.should include(vote)
  end

  it 'does not return an events votes for a user unless they voted' do
    event = EventDecorator.new(create(:event))
    user = event.owner
    suggestion = create(:suggestion, event: event)
    vote = create(:vote, suggestion: suggestion)

    user_votes = event.user_votes(user)

    user_votes.should_not include(vote)
  end
end

def event_with_invitees
  event = create(:event)
  invitation = create(:invitation_with_user, event: event)
  invitation = create(:invitation_with_guest, event: event)
  event
end
