step 'I vote for :suggestion_description for the :event_name again' do |suggestion_description, event_name|
  suggestion = PrimarySuggestion.
    find_by_description!(suggestion_description)
  event = Event.find_by_name!(event_name)
  page.driver.post('/votes', vote: { event_id: event.id,  suggestion_id: suggestion.id,
  suggestion_type: suggestion.class.name })
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

step 'I vote for secondary :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description, SecondarySuggestion)
end

step 'I should see that secondary :suggestion_description has :number vote(s)' do |suggestion_description, number|
  assert_vote_count(suggestion_description, number, SecondarySuggestion)
end

step 'I unvote for secondary :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description, SecondarySuggestion)
end
