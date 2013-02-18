# Login
step 'I enter my name and an invalid email' do
  guest_email = 'bears@'
  step %(I fill in the fields with "#{guest_email}" and "nil" then submit)
end

step 'I fill in the guest fields with :email and :name' do |email, name|
  step %(I fill in the fields with "#{email}" and "#{name}" then submit)
end

step 'I fill in the guest fields with only :email' do |email|
  fill_in 'guest_email', with: email
  click_button 'Begin Voting'
end

step 'no guest exists with email :email' do |email|
  guest = Guest.find_by_email(email)
  expect(guest).to be_nil
end

step 'I should be prompted to login or enter my name and email' do
  expect(page).to have_css('a#sign-in')
  expect(page).to have_css('form#new_guest')
  expect(page).to have_css('#guest_name')
  expect(page).to have_css('#guest_email')
end

step 'I should not be prompted to enter my name and email' do
  expect(page).to have_css('a#sign-in')
  expect(page).to_not have_css('form#new_guest')
  expect(page).to_not have_css('#guest_name')
  expect(page).to_not have_css('#guest_email')
end

step 'I should see my email address :email_address prepopulated' do |email|
  expect(find_field('guest_email').value).to eq email
end

step 'I should see my name :name prepopulated' do |name|
  expect(find_field('guest_name').value).to eq name
end

step 'I should see :message in the errors' do |message|
  expect(find('.errors')).to have_content(message)
end

# Email
step 'I should receive a vote confirmation email for :event_name' do |event_name|
  event = Event.find_by_name!(event_name)
  expect(email_body(last_email_sent)).to match /#{event_url(event)}/
end

# Navigation
step 'I go to yammer.com before I view the :event_name event' do |event_name|
  event = Event.find_by_name!(event_name)
  page.driver.header 'Referer', 'https://www.yammer.com'
  visit event_path(event)
end

step 'I go to another site before I view the :event_name event' do |event_name|
  event = Event.find_by_name!(event_name)
  page.driver.header 'Referer', 'https://www.google.com'
  visit event_path(event)
end
