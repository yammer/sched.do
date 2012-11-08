EMAIL_SEARCH_URL = YAMMER_HOST + '/api/v1/users/by_email.json?email='

step 'no sched.do user exists with email :email' do |email|
  User.find_by_email(email).should be_nil
end

step 'a Yammer user exists named :name with email :email' do |name, email|
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  users = Yam.get("/users/by_email", email: email)
  users[0]['id'].should be_present
end

step 'no Yammer user exists with email :email' do |email|
  FakeYammer.yammer_user_name = 'Wrong Name'
  FakeYammer.yammer_email = email + '.fake'
  users = Yam.get("/users/by_email", email: email)
  users.first.should_not be_present
end

step ':email signs up for Yammer as :name' do |email, name|
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  users = Yam.get("/users/by_email", email: email)
  users[0]['id'].should be_present
end
