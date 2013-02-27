step 'I fill in the event name with :value' do |value|
  fill_in 'event_name', with: value
end

step 'I suggest :suggestion' do |suggestion|
  find_field_by_data_role('primary-suggestion').set(suggestion)
end

step 'I add suggestion :suggestion' do |suggestion|
  all('input[data-role=primary-suggestion]').last.set(suggestion)
end

step 'I suggest an empty string' do
  find_field_by_data_role('primary-suggestion').set('')
end

step 'I successfully submit the create event form for :event_name' do |event_name|
  send 'I submit the create event form'
  expect(page).to have_content(event_name)
end

step 'I submit the create event form' do
  click_button 'Create event'
end

step 'I should see a presence error on the suggestion field' do
  expect_error_on_field_with_data_role("can't be blank", 'suggestion')
end

step 'I should see a length error on the event name field' do
  expect(find('#event_name_input')).to have_content('is too long')
end

step 'I create(d) an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  create_event(event_name, suggestion)
  expect(page).to have_content event_name
end

step 'someone created an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  as_random_user do
    create_event(event_name, suggestion)
    expect(page).to have_content event_name
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

step 'I create an event :event_name with the following suggestions:' do |event_name, table|
  create_event(event_name, table.raw)
  expect(page).to have_content(event_name)
end

step 'I create an event' do
  create_event
end

step 'I create an event named :event_name' do |event_name|
  create_event(event_name)
  expect(page).to have_content event_name
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
  expect(page).to have_content event_name
end

step 'I try to create an event with invalid data' do
  create_event('', [])
end

step 'I add another suggestion field' do
  expect(page).to have_css('.suggestions > .nested-fields')
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

step 'I sign in and fill in the event name as :event_name' do |event_name|
  sign_in
  fill_in 'event_name', with: event_name
end

step 'my network should see an activity message announcing the event' do
  expect(FakeYammer.activity_endpoint_hits).to eq 1
end

step 'I enter :secondary in the first secondary field' do |secondary|
  fill_in 'event_primary_suggestions_attributes_0_secondary_suggestions_attributes_0_description', with: secondary
end

step 'I should see :expected_time in the first secondary field' do |expected_time|
  expect(find('#event_primary_suggestions_attributes_0_secondary_suggestions_attributes_0_description').value).to eq expected_time
end

step 'I should see the appropriate change in the character counter' do
  max = Event::NAME_MAX_LENGTH
  expected_length = max - 10
  expect(find('.text-counter')).to have_content(expected_length)
end

step 'I should see :count in the text counter' do |count|
  expect(find('.text-counter')).to have_content(count)
end

step 'I enter a long name in the Event title field' do
  name = '1234567890' * 10
  fill_in 'event_name', with: name
end

step 'I should see a truncated name in the Event title field' do
  max = Event::NAME_MAX_LENGTH
  expect(find('#event_name').value.length).to eq max
end

step 'I created an event named :event_name with a suggestion of :primary with the following secondary suggestions:' do |event_name, primary, secondaries|
  suggestions = secondaries.raw.map(&:first)
  fill_in 'event_name', with: event_name
  all('input[data-role=primary-suggestion]')[0].set(primary)
  suggestions.each_with_index do |suggestion, index|
    all('input[data-role=secondary-suggestion]')[index]
      .set(suggestions[index]) 
    click_link 'Add Another Time'
  end
  click_button 'Create event'
  expect(page).to have_content(event_name)
end

step 'I should see :number :type fields' do |number, type|
  expect(all(".#{type}-suggestion", visible: true).count).to eq number.to_i
end
