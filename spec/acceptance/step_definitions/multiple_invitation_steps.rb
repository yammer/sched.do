step 'I should see a page asking me to invite people to the event' do
  expect(page).to have_content('Invite people to the event')
end

step 'I press the :button_text button for the :event_name event' do |button_text, event_name|
  click_button(button_text)
  expect(page).to have_content(event_name)
end

step 'I remove :user_name from the list of invited users' do |user_name|
  find('.remove').click
end

step 'I should not see :message' do |message|
  expect(page).to_not have_content(message)
end
