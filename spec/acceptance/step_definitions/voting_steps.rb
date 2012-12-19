step 'I vote for :suggestion_description again' do |suggestion_description|
  suggestion = Suggestion.find_by_primary!(suggestion_description)
  page.driver.post('/votes', vote: {suggestion_id: suggestion.id })
  visit(page.driver.response.header['Location'])
end

step 'I vote for :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description)
end

step 'I unvote for :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description)
end

step 'I should see that :suggestion_description has :number vote(s)' do |suggestion_description, number|
  assert_vote_count(suggestion_description, number)
end

step ':email_address votes for :suggestion_description' do |email_address, suggestion_description|
  vote_for(suggestion_description)
end
