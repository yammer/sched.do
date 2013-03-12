step 'I should see a suggestion of :suggestion' do |suggestion|
  within '.grid' do
    expect(page).to have_content suggestion
  end
end

step 'I should see :title in the header' do |title|
  within '.event-name' do
    expect(page).to have_content title
  end
end

step 'I visit the event page for :event_name' do |event_name|
  event = Event.find_by_name!(event_name)
  visit "/events/#{event.uuid}"
end

step 'I should not be able to access it by id' do
  create(:event)
  expect {
    visit "/events/#{Event.last.id}"
  }.to raise_error(ActionController::RoutingError)
end

step 'I view the :event_name event' do |event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
end

step 'I should not see an edit link' do
  expect(page).to have_no_css('a', text: 'Edit')
end

step 'I should not be able to remind everyone to vote' do
  expect(page).to have_no_css('a.remind-all')
end

step 'I should not be able to remind an individual user to vote' do
  expect(page).to have_no_css('a.remind')
end

step 'I should be on the :event_name event page' do |event_name|
  event = Event.find_by_name!(event_name)
  expect(current_url).to eq event_url(event)
end

step 'I should not be on the :event_name event page' do |event_name|
  event = Event.find_by_name(event_name)
  expect(current_url).to_not eq event_url(event)
end

step 'I should see an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  expect(page).to have_css('.event-name', text: event_name)

  within '.grid' do
    expect(page).to have_content suggestion
  end
end

step 'I should see an event with the following suggestions in order:' do |table|
  suggestions = table.raw
  within '.grid' do
    all('.description').each_with_index do |element, i|
      expect(element).to have_content suggestions[i][0]
      if suggestions[i][1]
        expect(element).to have_content suggestions[i][1]
      end
    end
  end
end

step 'I should see multiple suggestions' do
  expect(all("input[data-role='primary-suggestion']").size).to be > 1
end

step 'I should see an event with the following invitees in order:' do |table|
  expected_invitee_order = table.raw.flatten

  actual_invitee_order = page.all('.user-name').map do |name|
    name.text.gsub("\n", ' ').strip
  end

  expect(actual_invitee_order).to eq expected_invitee_order
end

step 'I should see :user_name within the created by section' do |user_name|
  within '.created-by' do
    expect(page).to have_content user_name
  end
end

step ':first_suggestion should appear before :second_suggestion in the list' do |first_suggestion, second_suggestion|
  within(:xpath, "//div[contains(@class, 'options')]//th[1]") do
    expect(page).to have_content(first_suggestion)
  end

  within(:xpath,  "//div[contains(@class, 'options')]//th[2]") do 
    expect(page).to have_content(second_suggestion)
  end
end

step 'I should see :event_name in my Events list' do |event_name|
  within '#my-events' do
    expect(page).to have_content(event_name)
  end
end
