module VotingHelpers
  def assert_vote_count(suggestion_primary, vote_count)
    wait_until {
      Suggestion.find_by_primary(suggestion_primary).present?
    }

    suggestion = Suggestion.find_by_primary!(suggestion_primary)

    within '.grid' do
      find(".vote-count[data-id='#{suggestion.id}']").text.strip.should == vote_count.to_s
    end
  end

  def vote_for(suggestion_primary)
    wait_until {
      Suggestion.find_by_primary(suggestion_primary).present?
    }

    suggestion = Suggestion.find_by_primary!(suggestion_primary)

    within '.grid' do
      find(".votable div[data-id='#{suggestion.id}'] input[name='commit']").click
    end
  end
end

RSpec.configure do |c|
  c.include VotingHelpers
end
