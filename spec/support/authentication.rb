module TurnipAuthenticationHelpers
  def sign_in
    visit root_path
    click_link 'Sign in with Yammer'
  end

  def sign_out
    click_link 'Sign out'
  end

  def fill_in_guest_info(guest_email = 'joe@example.com', guest_name = 'Joe Schmoe')
    within '#new_guest' do
      fill_in 'guest_name', with: guest_name
      fill_in 'guest_email', with: guest_email
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
        access_token: generate(:yammer_token),
        email: generate(:email),
        image: generate(:yammer_image_url),
        name: generate(:yammer_user_name),
        nickname: generate(:yammer_nickname),
        yammer_network_id: 1,
        yammer_profile_url: generate(:yammer_profile_url)
      },
        extra: generate(:extra)
    })
  end

  def create_named_yammer_account(yammer_name)
    OmniAuth.config.mock_auth[:yammer].merge!({
      uid: generate(:yammer_uid),
      info: {
        access_token: generate(:yammer_token),
        email: generate(:email),
        image: generate(:yammer_image_url),
        name: yammer_name,
        nickname: generate(:yammer_nickname),
        yammer_network_id: 1,
        yammer_profile_url: generate(:yammer_profile_url)
      },
        extra: generate(:extra)
    })
  end

  def rename_yammer_account(new_name)
    OmniAuth.config.mock_auth[:yammer][:info][:name] = new_name
  end

  def create_yammer_account_with_yammer_user_id(yammer_user_id)
    create_yammer_account.merge!({ uid: yammer_user_id })
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
