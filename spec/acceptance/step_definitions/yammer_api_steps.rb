step ':name should receive :count private message(s)' do |name, count|
  FakeYammer.messages_endpoint_hits.should == count.to_i
end

step ':name should receive a private reminder message' do |name|
  FakeYammer.message.should include('Reminder')
end

step 'the private message should include a link to :event_name' do |event_name|
  event = Event.find_by_name(event_name)
  FakeYammer.message.should include(event_url(event))
end

step 'the private reminder message sent should be from :name' do |name|
  sender = User.find_by_name!(name)
  FakeYammer.access_token.should == sender.access_token
end

step 'group :name should receive a private invitation message' do |name|
  group = Group.find_by_name!(name)
  expected_yammer_group_id = group.yammer_group_id.to_s
  received_yammer_group_id = FakeYammer.group_id
  received_yammer_group_id.should  == expected_yammer_group_id
end

step 'group :name should not receive a private invitation message' do |name|
  FakeYammer.group_id.should == 0
  FakeYammer.messages_endpoint_hits.should == 0
end

step 'the private invitation message should be sent regarding :event' do |event|
  FakeYammer.message.should include(event)
end

step 'the private invitation message sent should be from :sender' do |sender|
  sender = User.find_by_name!(sender)
  FakeYammer.access_token.should == sender.access_token
end
