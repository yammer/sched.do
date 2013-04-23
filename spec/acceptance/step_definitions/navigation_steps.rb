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

step 'I should be on the homepage' do
  expect(current_url).to eq root_url
end
