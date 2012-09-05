require 'spec_helper'

describe Vote do
  it { should belong_to(:suggestion) }
  it { should validate_presence_of(:suggestion_id) }
  it { should belong_to(:voter) }
  it { should validate_presence_of(:voter_id) }
  it { should validate_presence_of(:voter_type) }

  it 'is valid if the user has not already voted for the suggestion' do
    vote = build(:vote)

    vote.should be_valid
  end

  it 'is not valid if the user has already voted for the suggestion' do
    vote = create(:vote)
    duplicated_vote = build(
        :vote,
        suggestion: vote.suggestion,
        voter: vote.voter
    )

    duplicated_vote.should be_invalid
  end
end

describe Vote, '#event' do
  it 'returns the vote\'s event' do
    vote = create(:vote)
    vote.event.should == vote.suggestion.event
  end
end

describe Vote, '#create' do
  it 'creates a delayed job' do
    VoteCreatedJob.stubs(:enqueue)

    vote = create(:vote)

    VoteCreatedJob.should have_received(:enqueue).with(vote)
  end
end
