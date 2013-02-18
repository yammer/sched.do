require 'spec_helper'

describe Vote do
  it { expect(subject).to belong_to(:suggestion) }
  it { expect(subject).to validate_presence_of(:suggestion_id) }
  it { expect(subject).to belong_to(:voter) }
  it { expect(subject).to validate_presence_of(:voter_id) }
  it { expect(subject).to validate_presence_of(:voter_type) }

  it 'is valid if the user has not already voted for the suggestion' do
    vote = build(:vote)

    expect(vote).to be_valid
  end

  it 'is not valid if the user has already voted for the suggestion' do
    vote = create(:vote)
    duplicated_vote = build(
        :vote,
        suggestion: vote.suggestion,
        voter: vote.voter
    )

    expect(duplicated_vote).to be_invalid
  end
end

describe Vote, '#no_votes_witin_delay_window?' do
  include DelayedJobSpecHelper

  it 'is false if a second email is sent within the delay window' do
    first_vote = create(:vote)
    voter = first_vote.voter
    event = first_vote.event
    second_suggestion = create(:suggestion, event: event)
    second_vote = create(
      :vote,
      event: event,
      voter: voter,
      suggestion: second_suggestion
    )

    first_vote_check = first_vote.has_no_other_votes_within_delay_window?
    second_vote_check = second_vote.has_no_other_votes_within_delay_window?

    expect(first_vote_check).to be_false
    expect(second_vote_check).to be_true
  end

  it 'is true if two emails are sent outside the delay window' do
    first_vote = create(:vote)
    voter = first_vote.voter
    event = first_vote.suggestion.event
    second_suggestion = create(:suggestion, event: event)

    Timecop.freeze(VoteEmailJob::DELAY.from_now)
    second_vote = create(:vote, voter: voter, suggestion: second_suggestion)
    Timecop.return
    first_vote_check = first_vote.has_no_other_votes_within_delay_window?
    second_vote_check = second_vote.has_no_other_votes_within_delay_window?

    expect(first_vote_check).to be_true
    expect(second_vote_check).to be_true
  end
end

describe Vote, '#create' do
  it 'creates a delayed job' do
    VoteCreatedJob.stubs(:enqueue)

    vote = create(:vote)

    expect(VoteCreatedJob).to have_received(:enqueue).with(vote)
  end

  it 'caches the vote id on the invitation' do
    event = create(:event)
    suggestion = create(:suggestion, event: event)
    invitation = create(:invitation, event: event)
    vote = build(
      :vote, 
      event: event, 
      voter: invitation.invitee, 
      suggestion: suggestion
    )

    vote.save!

    expect(invitation.reload.vote).to eq vote
  end
end
