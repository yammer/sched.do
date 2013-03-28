step 'I visit the homepage' do
  visit root_path
end

step 'I am on the homepage' do
  visit root_path
end

step 'I visit my polls page' do
  visit polls_path
end

step 'I navigate to the dashboard' do
  visit dashboard_path
end

step 'I click :link' do |link|
  first(:link, link).click
end

step 'I should be on my profile page' do
  expect(current_url).to eq polls_url
end

step 'I cannot visit the edit page for :event_name' do |event_name|
  event = Event.find_by_name(event_name)
  expect {
    visit edit_event_path(event)
  }.to raise_error ActiveRecord::RecordNotFound
end
