step 'I fill in the event name with :value' do |value|
  fill_in 'event_name', with: value
end

step 'I suggest :suggestion' do |suggestion|
  find_field_by_data_role('primary-suggestion').set(suggestion)
end

step 'I suggest an empty string' do
  find_field_by_data_role('primary-suggestion').set('')
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
  as_random_user do
    create_event(event_name, suggestion)
  end
end

step 'someone created an event named :event_name' do |event_name|
  as_random_user do
    create_event(event_name)
  end
end

step 'someone created an event named :event_name with the following suggestions:' do |event_name, table|
  suggestions = table.raw.map(&:first)
  as_random_user do
    create_event(event_name, suggestions)
  end
end

step 'I create an event with the following suggestions:' do |table|
  create_event('Clown party', table.raw)
end

step 'I create an event' do
  create_event
end

step 'I create an event named :event_name' do |event_name|
  create_event(event_name)
end

step 'I try to create an event with invalid data' do
  create_event('', [])
end

step 'I add another suggestion field' do
  page.should have_css('.suggestions > .nested-fields')
  click_link 'Add Another Day'
end

step 'I visit the new event page' do
  visit root_path
end

step 'I fill out the event form with the following suggestions:' do |table|
  suggestions = table.raw
  fields = add_enough_fields_for_suggestions(suggestions)
  fill_in_fields_with_suggestions(fields, suggestions)
end

step 'I remove the first suggestion' do
  click_link 'Remove Suggestion'
end

step 'I sign in and fill in the event name' do
  sign_in
  fill_in 'event_name', with: 'something'
end
