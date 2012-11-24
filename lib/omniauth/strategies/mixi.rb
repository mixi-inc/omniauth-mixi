require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mixi < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.mixi-platform.com/2',
        :authorize_url => 'https://mixi.jp/connect_authorize.pl',
        :token_url => 'https://api.mixi-platform.com/2/token'
      }

      uid do
        user_info['id']
      end

      info do
        {
          'displayName' => user_info['displayName'],
          'profileUrl' => user_info['profileUrl'],
          'thumbnailUrl' => user_info['thumbnailUrl']
        }
      end

      extra do
        {
          :user_info => user_info
        }
      end

      def user_info
        access_token.options[:mode] = :query
        @user_info ||= access_token.get('/people/@me/@self').parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'mixi', 'Mixi'
