require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class YammerStaging < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, 'yammer_staging'

      option :client_options, {
        site: 'https://www.staging.yammer.com',
        authorize_url: '/dialog/oauth',
        token_url: '/oauth2/access_token.json'
      }

      # Available as request.env['omniauth.auth']['uid']
      uid { raw_info['id'] }

      info do
        {
          access_token: access_token.token,
          email: primary_email,
          image: raw_info['mugshot_url'],
          name: raw_info['full_name'],
          nickname: raw_info['name'],
          yammer_network_id: raw_info['network_id'],
          yammer_profile_url: raw_info['web_url']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def build_access_token
        access_token = super
        token = YammerAccessToken.new(access_token.token).real_token
        @access_token = ::OAuth2::AccessToken.new(client, token, access_token.params)
      end

      private

      def raw_info
        @raw_info ||= access_token.params['user']
      end

      def primary_email
        raw_info['contact']['email_addresses'].detect{|address| address['type'] == 'primary'}['address']
      end
    end
  end
end
