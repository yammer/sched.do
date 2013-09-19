step 'no sched.do user exists with email :email' do |email|
  expect(User.find_by_email(email)).to be_nil
end

step 'a Yammer user exists named :name with email :email' do |name, email|
  yammer = Yammer::Client.new(access_token: '123')
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  users = yammer.get_user_by_email(email).body
  expect(users[0][:id]).to be_present
end

step 'no Yammer user exists with email :email' do |email|
  yammer = Yammer::Client.new(access_token: '123')
  FakeYammer.yammer_user_name = 'Wrong Name'
  FakeYammer.yammer_email = email + '.fake'
  users = yammer.get_user_by_email(email).body
  expect(users).to_not be_present
end

step ':email signs up for Yammer as :name' do |email, name|
  yammer = Yammer::Client.new(access_token: '123')
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  users = yammer.get_user_by_email(email).body
  expect(users[0][:id]).to be_present
end
