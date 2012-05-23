step 'I have a Yammer account' do
  create_yammer_account
end

step 'I should see the sign-in welcome message' do
  page.should have_content 'You have successfully signed in.'
end

step 'I am signed in' do
  create_yammer_account
  sign_in
end

step 'I should be redirected to the new event page' do
  page.should have_content "Create a New Event"
end

step 'I should see :text' do |text|
  page.should have_content text
end
