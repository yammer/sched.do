module OmniAuthHelper
  def stub_omniauth_env
    request.env['omniauth.auth'] = OmniAuth.mock_auth_for(:yammer)
  end

  def stub_declined_tos
    request.env['omniauth.params'] = { 'agree_to_tos' => '0' }
  end
end
