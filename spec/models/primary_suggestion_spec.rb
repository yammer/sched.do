require 'spec_helper'

describe PrimarySuggestion do
  it { expect(subject).to validate_presence_of(:description).
       with_message(/This field is required/) }

  it { expect(subject).to belong_to :event }
  it { expect(subject).to have_many(:votes).dependent(:destroy) }

  it { expect(subject).to allow_mass_assignment_of(:description) }
  it { expect(subject).to allow_mass_assignment_of(:secondary_suggestions_attributes) }
end

describe PrimarySuggestion, '#vote_count' do
  it 'returns the number of votes for this suggestion' do
    suggestion = create(:suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)
    suggestion.votes << create(:vote, suggestion: suggestion)

    expect(suggestion.vote_count).to eq 2
  end

  it 'returns 0 votes when no votes exist' do
    suggestion = PrimarySuggestion.new
    expect(suggestion.vote_count).to eq 0
  end

  it 'returns 0 votes when an unpersisted vote shows up for no reason' do
    suggestion_with_unpersisted_vote = PrimarySuggestion.new
    suggestion_with_unpersisted_vote.votes.build
    expect(suggestion_with_unpersisted_vote.vote_count).to eq 0
  end
end

describe PrimarySuggestion, '#full_description' do 
  it 'returns the primary and secondary descriptions' do 
    suggestion = build(:suggestion, description: 'primary')

    expect(suggestion.full_description).to eq 'primary'
  end
end
