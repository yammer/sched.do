step 'I vote for :suggestion_description' do |suggestion_description|
  suggestion = Suggestion.find_by_description!(suggestion_description)

  within '.suggestions' do
    find(".vote[data-id='#{suggestion.id}'] input[name='commit']").click
  end
end

step 'I should see that that :suggestion_description has :number vote(s)' do |suggestion_description, number|
  suggestion = Suggestion.find_by_description!(suggestion_description)

  within '.suggestions' do
    find(".vote-count[data-id='#{suggestion.id}']").text.strip.should == number.to_s
  end
end
