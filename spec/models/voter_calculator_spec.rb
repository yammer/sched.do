require 'spec_helper'

describe VoterCalculator, '#voters' do
  it 'returns the users and guests that voted for this suggestion' do
    user = build(:user)
    guest = build(:guest)
    suggestion = build(:suggestion)
    suggestion.votes << build(:vote, voter: user)
    suggestion.votes << build(:vote, voter: guest)
    voter_calculator = VoterCalculator.new(suggestion)

    expect(voter_calculator.voters).to eq [user, guest]
  end
end

describe VoterCalculator, '#non_voters' do
  it 'returns the users and guests that did not vote for this suggestion' do
    user1 = build(:user)
    user2 = build(:user)
    guest = build(:guest)
    event = build(:event)
    vote = stub(voter: user2)
    event.stubs(users: [user1, user2], guests: [guest])
    suggestion = build(:suggestion, event: event)
    suggestion.stubs(votes: [vote])
    voter_calculator = VoterCalculator.new(suggestion)

    expect(voter_calculator.non_voters).to eq [user1, guest]
  end
end
