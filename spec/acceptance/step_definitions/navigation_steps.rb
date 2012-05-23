step 'I visit the homepage' do
  visit root_path
end

step 'I click :link' do |link|
  click_link link
end
