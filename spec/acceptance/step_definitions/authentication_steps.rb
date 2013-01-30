step 'I have a Yammer account' do
  mock_yammer_oauth
end

step 'I am signed in as :email' do |email|
  mock_yammer_oauth(email)
  sign_in
end

step 'I am signed in' do
  mock_yammer_oauth
  sign_in
end

step 'I sign in as a different user' do
  sign_out
  mock_yammer_oauth
  sign_in
end

step 'I deny access to Yammer' do
  mock_deny_yammer_oauth
  sign_in
end

step 'I sign out' do
  sign_out
end

step 'I am signed in as :name and I view the page for :event' do |name, event|
  step %(a Yammer user exists named "#{name}" with email 'temp@example.com')
  step %(I am signed in as 'temp@example.com')
  step %(I visit the event page for "#{event}")
end

step 'I am signed in as a guest' do
  visit new_guest_path(event_id: Event.last.uuid)
  step 'I fill in the fields then submit'
end

step 'I am signed in as the guest :guest_email' do |guest_email|
  visit new_guest_path(event_id: Event.last.uuid)
  step %(I fill in the fields with "#{guest_email}" and 'nil' then submit)
end

step 'I am signed in as the guest :email named :name' do |email, name|
  visit new_guest_path(event_id: Event.last.uuid)
  step %(I fill in the fields with "#{email}" and "#{name}" then submit)
end

step 'I view the login form for the :event event' do |event_name|
  event = Event.find_by_name!(event_name)
  visit new_guest_url(event_id: event.uuid)
end

step 'I have a Yammer account with name :name' do |name|
  named_fake_yammer(name)
  sign_in
end

step 'I change my name to :new_name' do |new_name|
  change_fake_yammer_fullname(new_name)
end

step 'I log out and sign back in again' do
  step 'I sign out'
  step 'I visit the homepage'
  step "I press 'Sign in with Yammer'"
end

step 'I fill in the fields then submit' do
  step %(I fill in the fields with "#{nil}" and "#{nil}" then submit)
end

step 'I fill in the fields with :email and :name then submit' do |email, name|
  email ||= 'joe@example.com'
  name ||= 'Joe Schmoe'
  fill_in 'guest_name', with: name
  fill_in 'guest_email', with: email
  click_button 'Begin Voting'
end

# Should

step 'I should be redirected to the new event page' do
  page.should have_content 'Schedule an Event'
end

step 'I should not see a sign out button' do
  page.should have_no_content 'Sign out'
end

step 'I should be signed out' do
  current_url.should == root_url
end
