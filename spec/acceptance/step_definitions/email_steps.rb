step ':email_address should receive an email' do |email_address|
  unread_emails_for(email_address).size.should == 1
end

step ':email_address should receive an email with the text :email_text' do |email_address, email_text|
  unread_emails_for(email_address).size.should == 1
  email_body(last_email_sent).should =~ /#{Regexp.escape(email_text)}/
end

step ':email_address follows the link :link in his email' do |email_address, link|
  open_email(email_address)
  visit_in_email(link)
end
step ':email_address should receive a vote confirmation email with a link to :event' do |email_address, event|
  event = Event.find_by_name(event)
  email_body(last_email_sent).should have_link("change your vote", href: event_url(event))
end

step ':email_address should have :count email(s)' do |email_address, count|
  mailbox_for(email_address).size.should == count.to_i
end

step 'out-network Yammer user :name should get an email notification' do |name|
  user = User.find_by_name!(name)
  mailbox_for(user.email).size.should == 1
end
