require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mixi < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'r_profile'

      option :client_options, {
        :site => 'https://api.mixi-platform.com',
        :authorize_url => 'https://mixi.jp/connect_authorize.pl',
        :token_url => 'https://api.mixi-platform.com/2/token'
      }

      option :authorize_options, [:scope, :display]

      uid do
        raw_info['id']
      end

      info do
        {
          'name' => raw_info['displayName'],
          'nickname' => raw_info['displayName'],
          'urls' => {
            'Profile' => raw_info['profileUrl']
          },
          'image' => raw_info['thumbnailUrl']
        }
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        hash
      end

      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||= access_token.get('/2/people/@me/@self').parsed
      end

      def authorize_params
        super.tap do |params|
          %w[display state scope].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end
          params[:scope] ||= DEFAULT_SCOPE
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'mixi', 'Mixi'
