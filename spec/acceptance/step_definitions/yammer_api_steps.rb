step ':name should receive :count private message(s)' do |name, count|
  expect(FakeYammer.messages_endpoint_hits).to eq count.to_i
end

step ':name should receive a private reminder message' do |name|
  expect(FakeYammer.message).to include('Reminder')
end

step 'the private message should include a link to :event_name' do |event_name|
  event = Event.find_by_name(event_name)
  expect(FakeYammer.message).to include(event_url(event))
end

step 'the private reminder message sent should be from :name' do |name|
  sender = User.find_by_name!(name)
  expect(FakeYammer.access_token).to eq sender.access_token
end

step 'group :name should receive a private invitation message' do |name|
  group = Group.find_by_name!(name)
  expected_yammer_group_id = group.yammer_group_id.to_s
  received_yammer_group_id = FakeYammer.group_id
  expect(received_yammer_group_id).to eq expected_yammer_group_id
end

step 'group :name should not receive a private invitation message' do |name|
  expect(FakeYammer.group_id).to eq 0
  expect(FakeYammer.messages_endpoint_hits).to eq 0
end

step 'the private invitation message should be sent regarding :event' do |event|
  expect(FakeYammer.message).to include(event)
end

step 'the private invitation message sent should be from :sender' do |sender|
  sender = User.find_by_name!(sender)
  expect(FakeYammer.access_token).to eq sender.access_token
end
