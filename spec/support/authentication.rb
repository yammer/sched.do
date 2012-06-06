module TurnipAuthenticationHelpers
  def create_yammer_account
    OmniAuth.config.mock_auth[:yammer] = {
      provider: 'yammer',
      uid: '12345',
      info: {
        name: 'Jim Bob',
        email: 'jimbob@example.com'
      }
    }
  end

  def sign_in
    visit root_path
    click_link 'Sign in with Yammer'
  end

  def sign_out
    click_link 'Sign out'
  end
end

module AuthenticationHelpers
  def sign_in_as(user)
    @controller.current_user = user
  end
end

RSpec.configure do |c|
  c.include TurnipAuthenticationHelpers
  c.include AuthenticationHelpers
end
