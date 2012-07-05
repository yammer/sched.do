step 'I vote for :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description)
end

step 'I unvote for :suggestion_description' do |suggestion_description|
  vote_for(suggestion_description)
end

step 'I should see that :suggestion_description has :number vote(s)' do |suggestion_description, number|
  assert_vote_count(suggestion_description, number)
end
