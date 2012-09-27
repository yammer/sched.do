step 'I click on the event title' do
  find('.event-name h1').click
end

step 'I fill in the title with :event_name' do |event_name|
  find('.event-name input').set(event_name)
end

step 'I blur the title field' do
  page.execute_script("$('.event-name input').trigger('blur');")
end

step 'I should see that the event was not successfully updated' do
  find('#flash-failure').should have_content 'Please check the errors and try again.'
end

step 'I update the message with the text :message_text' do |message_text|
  find('#event_message').set(message_text)
  find('#event_submit_action input').click
end

step 'I edit the event' do
  find('.edit-button').click
end
