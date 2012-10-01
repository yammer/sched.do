require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class YammerStaging < OmniAuth::Strategies::Yammer
      option :name, 'yammer_staging'

      option :client_options, {
        site: 'https://www.staging.yammer.com',
        authorize_url: '/dialog/oauth',
        token_url: '/oauth2/access_token.json'
      }
    end
  end
end
