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
  find('#flash_success').should have_content 'Event successfully created.'
end

step 'I should see a presence error on the suggestion field' do
  expect_error_on_field_with_data_role("can't be blank", 'suggestion')
end

step 'I created an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  visit root_path
  fill_in 'event_name', with: event_name
  find_field_by_data_role('suggestion').set(suggestion)
  click_button 'Create event'
end
