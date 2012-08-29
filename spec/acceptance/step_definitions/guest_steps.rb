step 'I should be prompted to login or enter my name and email' do
  page.should have_css('a#sign-in')
  page.should have_css('form#new_guest')
  page.should have_css('#guest_name')
  page.should have_css('#guest_email')
end

step 'I should not be prompted to enter my name and email' do
  page.should have_css('a#sign-in')
  page.should_not have_css('form#new_guest')
  page.should_not have_css('#guest_name')
  page.should_not have_css('#guest_email')
end

step 'I enter my name and email' do
  fill_in_guest_info
end

step 'I enter my name and an invalid email' do
  fill_in_guest_info(guest_email: 'bears@')
end

step 'I should receive a vote confirmation email for :event_name' do |event_name|
  event = Event.find_by_name!(event_name)
  email_body(last_email_sent).should =~ /#{event_url(event)}/
end

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

step 'I should see my email address :email_address prepopulated' do |email|
  find_field('guest_email').value.should == email
end

step 'I should see my name :name prepopulated' do |name|
  find_field('guest_name').value.should == name
end
