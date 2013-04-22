require 'spec_helper'

describe PrimarySuggestion do
  it { expect(subject).to validate_presence_of(:description).
       with_message(/This field is required/) }

  it { expect(subject).to belong_to :event }
  it { expect(subject).to have_many(:votes).dependent(:destroy) }
  it do 
    expect(subject).to(
      have_many(:secondary_suggestions).dependent(:destroy)
    )
  end

  it { expect(subject).to allow_mass_assignment_of(:description) }
  it do
    expect(subject).to(
      allow_mass_assignment_of(:secondary_suggestions_attributes)
    )
  end
end

describe PrimarySuggestion, '#vote_count' do
  it 'returns the number of votes for this suggestion' do
    suggestion = create(:suggestion)
    create(:vote, suggestion: suggestion)
    create(:vote, suggestion: suggestion)

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
  it 'returns the primary description' do
    suggestion = build(:suggestion, description: 'Monday')

    expect(suggestion.full_description).to eq 'Monday'
  end

  context 'with secondary suggestions' do
    it 'returns the primary and secondary descriptions' do
      secondary1 = build(:secondary_suggestion, description: '10:00pm')
      secondary2 = build(:secondary_suggestion, description: '10:00am')
      suggestion = build(
        :suggestion,
        description: 'Monday',
        secondary_suggestions: [secondary1, secondary2]
      )

      expect(suggestion.full_description).to eq 'Monday 10:00am 10:00pm'
    end
  end
end

describe PrimarySuggestion, '#suggestions' do
  it 'returns sorted secondary suggestions' do
    secondary1 = build(:secondary_suggestion, description: '10pm')
    secondary2 = build(:secondary_suggestion, description: '10am')
    suggestion = build(:suggestion, secondary_suggestions: [secondary1, secondary2])

    expect(suggestion.suggestions).to eq [secondary2, secondary1]
  end
end
