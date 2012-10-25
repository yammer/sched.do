module TurnipAuthenticationHelpers
  def sign_in
    visit root_path
    click_button 'Sign in with Yammer'
  end

  def sign_out
    click_link 'Sign out'
  end

  def as_random_user
    mock_yammer_oauth
    sign_in
    yield
    sign_out
  end
end

module AuthenticationHelpers
  def mock_yammer_oauth(email = nil, token = generated_token)
    email ||= generate(:email)
    OmniAuth.config.mock_auth[:yammer] = {
      uid: generate(:yammer_uid),
      info: {
        email: email,
        image: generate(:image),
        name: generate(:yammer_user_name),
        nickname: generate(:yammer_nickname),
        yammer_network_id: 1,
        yammer_profile_url: generate(:yammer_profile_url)
      },
      credentials: {
        token: token
      },
      extra: generate(:extra)
    }
  end

  def mock_deny_yammer_oauth
    OmniAuth.config.mock_auth[:yammer] = :invalid_credentials
  end

  def named_fake_yammer(yammer_name)
    FakeYammer.yammer_user_name = yammer_name
  end

  def change_fake_yammer_fullname(new_name)
    FakeYammer.yammer_user_name = new_name
  end

  def create_yammer_account_with_yammer_user_id(yammer_user_id)
    mock_yammer_oauth.merge!({ uid: yammer_user_id })
  end

  def sign_in_as(user)
    @controller.current_user = user
  end

  def sign_out
    click_link 'Sign out'
  end

  private

  def generated_token
    FactoryGirl.generate(:yammer_token)
  end
end

RSpec.configure do |c|
  c.include TurnipAuthenticationHelpers, type: :request
  c.include AuthenticationHelpers
end
