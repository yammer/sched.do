step 'I should be prompted to login or enter my name and email' do
  page.should have_css('a#sign-in')
  page.should have_css('form#new_guest')
end

step 'I enter my name and email' do
  fill_in_guest_info
end

step 'I should receive a vote confirmation email for :event_name' do |event_name|
  event = Event.find_by_name!(event_name)
  email_body(last_email_sent).should =~ /#{event_url(event)}/
end
