step 'I fill in the event name with :value' do |value|
  fill_in 'event_name', with: value
end

step 'I fill in the event time with :value' do |value|
  find_field_by_data_role('time').set(value)
end

step 'I submit the create event form' do
  click_button 'Create event'
end

step 'I should see that the event was successfully created' do
  find('#flash_success').should have_content 'Event successfully created.'
end

step 'I should see an error relating to the future on the time field' do
  expect_error_on_field_with_data_role('must be in the future', 'time')
end

step 'I should see a presence error on the time field' do
  expect_error_on_field_with_data_role("can't be blank", 'time')
end

step 'I should see that the time field has an invalid time' do
  expect_error_on_field_with_data_role('not a valid datetime', 'time')
end

step 'I created an event named :event_name at :time' do |event_name, time|
  visit root_path
  fill_in 'event_name', with: event_name
  find_field_by_data_role('time').set(time)
  click_button 'Create event'
end
