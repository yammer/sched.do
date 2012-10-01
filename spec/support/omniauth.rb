OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:yammer] = {
  provider: 'yammer',
  uid: FactoryGirl.generate(:yammer_uid),
  info: {
    name: FactoryGirl.generate(:yammer_user_name),
    email: FactoryGirl.generate(:email),
    yammer_profile_url: FactoryGirl.generate(:yammer_profile_url),
    yammer_network_id: 1
  },
  credentials: {
    token: FactoryGirl.generate(:yammer_token)
  }
}
