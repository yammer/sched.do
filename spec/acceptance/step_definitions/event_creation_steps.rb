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

step 'I should see a presence error on the suggestion field' do
  expect_error_on_field_with_data_role("can't be blank", 'suggestion')
end

step 'I should see a length error on the event name field' do
  find('#event_name_input').should have_content('is too long')
end

step 'I create(d) an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  create_event(event_name, suggestion)
end

step 'someone created an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  as_random_user do
    create_event(event_name, suggestion)
  end
end

step 'someone :profile_image a profile image created an event named :event_name with a suggestion of :suggestion' do |profile_image, event_name, suggestion|
  send 'someone created an event named :event_name with a suggestion of :suggestion', event_name, suggestion
  user = Event.find_by_name(event_name).owner
  user.image = profile_image
  user.save
end

placeholder :profile_image do
  match /without/ do
    'no_photo.png'
  end

  match /with/ do
    'i_have_a_photo.png'
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

step 'I sign in and try to create an event named :event_name' do |event_name|
  mock_yammer_oauth
  sign_in
  create_event(event_name)
end

step 'I sign in and create an event named :event_name' do |event_name|
  mock_yammer_oauth
  sign_in
  create_event(event_name)
  page.should have_content event_name
end

step 'I try to create an event with invalid data' do
  create_event('', [])
end

step 'I add another suggestion field' do
  page.should have_css('.suggestions > .nested-fields')
  click_link 'Add Another Date'
end

step 'I visit the new event page' do
  visit root_path
end

step 'I fill out the event form with the following suggestions:' do |table|
  suggestion_manager = EventCreation::SuggestionManager.new(table.raw, page)
  suggestion_manager.fill_in_fields
end

step 'I remove the first suggestion' do
  click_link 'Remove Suggestion'
end

step 'I sign in and fill in the event name' do
  sign_in
  fill_in 'event_name', with: 'something'
end

step 'my network should see an activity message announcing the event' do
  FakeYammer.activity_endpoint_hits.should == 1
end

step 'I enter :secondary in the first secondary field' do |secondary|
  fill_in "event_suggestions_attributes_0_secondary", with: secondary
end

step 'I should see :expected_time in the first secondary field' do |expected_time|
  find("#event_suggestions_attributes_0_secondary").value.should == expected_time
end

step 'I should see the appropriate change in the character counter' do
  max = Event::NAME_MAX_LENGTH
  expected_length = max - 10
  find(".text-counter").should have_content(expected_length)
end

step 'I should see :count in the text counter' do |count|
  find(".text-counter").should have_content(count)
end

step 'I enter :name in the name field' do |name|
  fill_in "event_name", with: name
end

step 'I enter a long name in the Event title field' do
  name = '1234567890' * 10
  fill_in "event_name", with: name
end

step 'I should see a truncated name in the Event title field' do
  max = Event::NAME_MAX_LENGTH
  find("#event_name").value.length.should == max
end
