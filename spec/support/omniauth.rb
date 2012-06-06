OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:yammer] = {
  provider: 'yammer',
  uid: FactoryGirl.generate(:yammer_uid),
  info: {
    name: FactoryGirl.generate(:yammer_user_name),
    email: FactoryGirl.generate(:email),
    access_token: OpenStruct.new(token: FactoryGirl.generate(:yammer_token))
  }
}
