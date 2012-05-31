step 'I submit the create event form' do
  click_button 'Create event'
end

step 'I should see that the event was successfully created' do
  find('#flash_success').should have_content 'Event successfully created.'
end

step 'I created an event named :event_name at :time' do |event_name, time|
  visit root_path
  fill_in 'Name', with: event_name
  fill_in 'Time', with: time
  click_button 'Create event'
end
