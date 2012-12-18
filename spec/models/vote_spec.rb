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

describe Vote, '#no_votes_witin_delay_window?' do
  include DelayedJobSpecHelper

  it 'is false if a second email is sent within the delay window' do
    first_vote = create(:vote)
    voter = first_vote.voter
    event = first_vote.suggestion.event
    second_suggestion = create(:suggestion, event: event)
    second_vote = create(:vote, voter: voter, suggestion: second_suggestion)

    first_vote_check = first_vote.has_no_other_votes_within_delay_window?
    second_vote_check = second_vote.has_no_other_votes_within_delay_window?

    first_vote_check.should be_false
    second_vote_check.should be_true
  end

  it 'is true if two emails are sent outside the delay window' do
    first_vote = create(:vote)
    voter = first_vote.voter
    event = first_vote.suggestion.event
    second_suggestion = create(:suggestion, event: event)

    Timecop.freeze(VoteConfirmationEmailJob::DELAY.from_now)
    second_vote = create(:vote, voter: voter, suggestion: second_suggestion)
    Timecop.return
    first_vote_check = first_vote.has_no_other_votes_within_delay_window?
    second_vote_check = second_vote.has_no_other_votes_within_delay_window?

    first_vote_check.should be_true
    second_vote_check.should be_true
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

  it 'caches the vote id on the invitation' do
    event = create(:event)
    suggestion = create(:suggestion, event: event)
    invitation = create(:invitation, event: event)
    vote = build(:vote, voter: invitation.invitee, suggestion: suggestion)

    vote.save!

    invitation.reload.vote.should == vote
  end
end
