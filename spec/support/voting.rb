module VotingHelpers
  def assert_vote_count(suggestion_description, vote_count)
    suggestion = Suggestion.find_by_primary!(suggestion_description)

    within '.suggestions' do
      find(".vote-count[data-id='#{suggestion.id}']").text.strip.should == vote_count.to_s
    end
  end

  def vote_for(suggestion_description)
    suggestion = Suggestion.find_by_primary!(suggestion_description)

    within '.suggestions' do
      find(".vote[data-id='#{suggestion.id}'] input[name='commit']").click
    end
  end
end

RSpec.configure do |c|
  c.include VotingHelpers
end
