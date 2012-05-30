step 'I submit the create event form' do
  click_button 'Create event'
end

step 'I should see that the event was successfully created' do
  page.should have_content 'Event successfully created.'
end
