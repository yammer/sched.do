step ':email_address should receive an email' do |email_address|
  unread_emails_for(email_address).size.should == 1
end

step ':email_address should receive an email with the text :email_text' do |email_address, email_text|
  unread_emails_for(email_address).size.should == 1
  email_body(last_email_sent).should =~ /#{Regexp.escape(email_text)}/
end

step ':email_address should have :count email(s)' do |email_address, count|
  mailbox_for(email_address).size.should == count.to_i
end

