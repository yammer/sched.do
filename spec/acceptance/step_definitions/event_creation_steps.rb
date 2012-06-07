step 'I fill in the event name with :value' do |value|
  fill_in 'event_name', with: value
end

step 'I suggest :suggestion' do |suggestion|
  find_field_by_data_role('suggestion').set(suggestion)
end

step 'I suggest an empty string' do
  find_field_by_data_role('suggestion').set('')
end

step 'I submit the create event form' do
  click_button 'Create event'
end

step 'I should see that the event was successfully created' do
  find('#flash-success').should have_content 'Event successfully created.'
end

step 'I should see a presence error on the suggestion field' do
  expect_error_on_field_with_data_role("can't be blank", 'suggestion')
end

step 'I create(d) an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  create_event(event_name, suggestion)
end

step 'someone created an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  create_event(event_name, suggestion)
  sign_out
end

step 'I create an event with the following suggestions:' do |table|
  suggestions = table.raw.map(&:first)
  create_event('Clown party', suggestions)
end

step 'I try to create an event with invalid data' do
  create_event('', [])
end

step 'I should see multiple suggestions' do
  all('input[data-role=suggestion]').size.should be > 1
end
