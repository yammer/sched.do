step ':email_address should receive an email' do |email_address|
  unread_emails_for(email_address).size.should == 1
end
