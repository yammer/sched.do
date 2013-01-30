require 'spec_helper'

describe PrimarySuggestion do
  it { should validate_presence_of(:description).
       with_message(/This field is required/) }

  it { should belong_to :event }
  it { should have_many(:votes).dependent(:destroy) }

  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:secondary_suggestions_attributes) }
end

describe PrimarySuggestion, '#vote_count' do
  it 'returns the number of votes for this suggestion' do
    suggestion = create(:suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)

    suggestion.vote_count.should == 2
  end

  it 'returns 0 votes when no votes exist' do
    suggestion = PrimarySuggestion.new
    suggestion.vote_count.should == 0
  end

  it 'returns 0 votes when an unpersisted vote shows up for no reason' do
    suggestion_with_unpersisted_vote = PrimarySuggestion.new
    suggestion_with_unpersisted_vote.votes.build
    suggestion_with_unpersisted_vote.vote_count.should == 0
  end
end

describe PrimarySuggestion, '#full_description' do 
  it 'returns the primary and secondary descriptions' do 
    suggestion = build(:suggestion, description: 'primary')

    suggestion.full_description.should == 'primary'
  end
end
