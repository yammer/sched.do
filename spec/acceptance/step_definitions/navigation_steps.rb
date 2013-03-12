step 'I visit the homepage' do
  visit root_path
end

step 'I am on the homepage' do
  visit root_path
end

step 'I visit my polls page' do
  visit polls_path
end

step 'I click :link' do |link|
  click_link link
end

step 'I should be on my profile page' do
  expect(current_url).to eq polls_url
end
