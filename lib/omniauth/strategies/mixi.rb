require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mixi < OmniAuth::Strategies::OAuth2
      MINIMUM_SCOPE = 'r_profile'
      BASIC_SCOPE = ([MINIMUM_SCOPE] + ['name',
                                        'location',
                                        'about_me'].map {|scope|
                       "#{MINIMUM_SCOPE}_#{scope}"
                     }).join(' ')

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
        prune!({
                 'name' => real_name[:name],
                 'first_name' => real_name[:first_name],
                 'last_name' => real_name[:last_name],
                 'description' => raw_info['aboutMe'],
                 'location' => location,
                 'nickname' => raw_info['displayName'],
                 'urls' => {
                   'profile' => raw_info['profileUrl']
                 },
                 'image' => raw_info['thumbnailUrl']
               })
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        prune!(hash)
      end

      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||=
          access_token.get('/2/people/@me/@self?fields=@all').parsed['entry']
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          %w[display state scope].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end
          unless params[:scope]
            if options[:info_level] == :min
              params[:scope] = MINIMUM_SCOPE
            else
              params[:scope] = BASIC_SCOPE
            end
          end
        end
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def real_name
        name = raw_info['name']
        if name
          {
            :name => "#{name['familyName']} #{name['givenName']}",
            :first_name => name['givenName'],
            :last_name => name['familyName']
          }
        else
          {
            :name => raw_info['displayName'],
            :first_name => nil,
            :last_name => nil
          }
        end
      end

      def location
        prefecture = nil
        addresses = raw_info['addresses']
        if addresses
          addresses.each do |address|
            prefecture = "#{address['region']}#{address['locality']}"
            break if address['type'] == 'location'
          end
        end
        prefecture
      end
    end
  end
end

OmniAuth.config.add_camelization 'mixi', 'Mixi'
