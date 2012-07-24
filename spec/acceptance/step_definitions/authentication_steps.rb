step 'I have a Yammer account' do
  create_yammer_account
end

step 'I am signed in' do
  create_yammer_account
  sign_in
end

step 'I sign in as a different user' do
  sign_out
  create_yammer_account
  sign_in
end

step 'I should be redirected to the new event page' do
  page.should have_content "Schedule an Event"
end

step 'I sign out' do
  sign_out
end

step 'I am signed in as a guest' do
  visit new_guest_path
  fill_in_guest_info
end

step 'I am signed in as the guest :guest_email' do |guest_email|
  visit new_guest_path
  fill_in_guest_info(guest_email)
end

step 'I am signed in as the guest :guest_email named :guest_name' do |guest_email, guest_name|
  visit new_guest_path
  fill_in_guest_info(guest_email, guest_name)
end

step 'I should not see a sign out button' do
  page.should have_no_content 'Sign out'
end

step 'I have a Yammer account with name :name' do |name|
  create_named_yammer_account(name)
  sign_in
end

step 'I change my name to :new_name' do |new_name|
  rename_yammer_account(new_name)
end

step 'I log out and sign back in again' do
  step "I sign out"
  step "I visit the homepage"
  step "I click 'Sign in with Yammer'"
end
