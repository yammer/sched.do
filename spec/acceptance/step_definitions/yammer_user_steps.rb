step 'no sched.do user exists with email :email' do |email|
  User.find_by_email(email).should be_nil
end

step 'a Yammer user exists named :name with email :email' do |name, email|
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  url = 'https://www.yammer.com/api/v1/users/by_email.json?email=' + email
  returned = RestClient.get url
  returned.code.should == 200
  json = JSON.parse(returned)
  json[0]['id'].should_not be_nil
end

step 'no Yammer user exists with email :email' do |email|
  FakeYammer.yammer_user_name = 'Wrong Name'
  FakeYammer.yammer_email = email + '.fake'
  url = 'https://www.yammer.com/api/v1/users/by_email.json?email=' + email
  returned = RestClient.get url
  returned.code.should == 200
  returned.should_not be_present
end

step ':email signs up for Yammer as :name' do |email, name|
  FakeYammer.yammer_user_name = name
  FakeYammer.yammer_email = email
  url = 'https://www.yammer.com/api/v1/users/by_email.json?email=' + email
  returned = RestClient.get url
  returned.code.should == 200
  json = JSON.parse(returned)
  json[0]['id'].should_not be_nil
end
