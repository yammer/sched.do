require 'spec_helper'

describe SecondarySuggestion do
  it { should validate_presence_of(:description).
       with_message(/This field is required/) }

  it { should belong_to :primary_suggestion }
  it { should have_many(:votes).dependent(:destroy) }

  it { should allow_mass_assignment_of(:description) }
end

describe SecondarySuggestion, '#vote_count' do
  it 'returns the number of votes for this suggestion' do
    suggestion = create(:secondary_suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)

    suggestion.vote_count.should == 2
  end

  it 'returns 0 votes when no votes exist' do
    suggestion = SecondarySuggestion.new
    suggestion.vote_count.should == 0
  end

  it 'returns 0 votes when an unpersisted vote shows up for no reason' do
    suggestion_with_unpersisted_vote = SecondarySuggestion.new
    suggestion_with_unpersisted_vote.votes.build
    suggestion_with_unpersisted_vote.vote_count.should == 0
  end
end

describe SecondarySuggestion, '#event' do
  it 'returns the event the Primary Suggestion belongs to' do 
    suggestion = build(:secondary_suggestion)

    suggestion.event.should == suggestion.primary_suggestion.event
  end
end

describe SecondarySuggestion, '#full_description' do 
  it 'returns the primary and secondary descriptions' do 
    suggestion = build(:secondary_suggestion, description: 'secondary')
    suggestion.primary_suggestion.description = 'primary'

    suggestion.full_description.should == 'primary, secondary'
  end
end
