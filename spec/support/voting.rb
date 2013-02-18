module VotingHelpers
  def assert_vote_count(description, count, suggestion_type=PrimarySuggestion)
    suggestion = suggestion_type.
      find_by_description!(description)

    within '.grid' do
      expect(find(".vote-count[data-id='#{suggestion.id}']").text.strip).to eq count.to_s
    end
  end

  def vote_for(description, suggestion_type=PrimarySuggestion)
    suggestion = suggestion_type.
      find_by_description!(description)

    within '.grid' do
      find(".votable div[data-id='#{suggestion.id}'] input[name='commit']").click
    end
  end
end

RSpec.configure do |c|
  c.include VotingHelpers
end
