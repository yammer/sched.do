module TurnipAuthenticationHelpers
  def sign_in
    visit root_path
    click_link 'Sign in with Yammer'
  end

  def sign_out
    click_link 'Sign out'
  end

  def fill_in_guest_info
    within '#new_guest' do
      fill_in 'guest_name', with: 'Joe Schmoe'
      fill_in 'guest_email', with: 'joe@example.com'
      click_button 'Begin Voting'
    end
  end

  def as_random_user
    create_yammer_account
    sign_in
    yield
    sign_out
  end
end

module AuthenticationHelpers
  def create_yammer_account
    OmniAuth.config.mock_auth[:yammer].merge!({
      uid: generate(:yammer_uid),
      info: {
        name: generate(:yammer_user_name),
        email: generate(:email),
        access_token: generate(:yammer_token)
      }
    })
  end

  def sign_in_as(user)
    @controller.current_user = user
  end

  def sign_out
    click_link 'Sign out'
  end
end

RSpec.configure do |c|
  c.include TurnipAuthenticationHelpers, type: :request
  c.include AuthenticationHelpers
end
