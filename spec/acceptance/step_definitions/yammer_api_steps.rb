step ':name should receive :count private message(s)' do |name, count|
  FakeYammer.messages_endpoint_hits.should == count.to_i
end

step ':name should receive a private reminder message' do |name|
  FakeYammer.message.should include("Reminder")
end

step 'the private reminder message sent should be from :name' do |name|
  sender = User.find_by_name!(name)
  FakeYammer.access_token.should == sender.access_token
end
