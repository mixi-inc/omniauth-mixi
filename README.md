# OmniAuth mixi

This gem contains the mixi strategy for OmniAuth.

mixi uses the OAuth2 server flow, you can read about it here: http://developer.mixi.co.jp/en/connect/mixi_graph_api/api_auth/

## How To Use It

So let's say you're using Rails, you need to add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-mixi'
```
(11/26/2012) This is not registered to Rubygems yet.

You can also pull them in directly from Github e.g.:

```ruby
gem 'omniauth-mixi', git => 'https://github.com/yoichiro/omniauth-mixi.git'
```

Then `bundle install` to install dependencies.

Once these are in, you need to add the following to your `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mixi, 'consumer_key', 'consumer_secret'
end
```

You will obviously have to put in your key and secret, which you get when you register your app with Partner Dashboard.

When you define like the Builder above, you will retrieve basic user's informations. If you want to retrieve minimum information set only, the parameter `:info_level` can be used:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mixi, 'consumer_key', 'consumer_secret', :info_level => :min
end
```

Now just follow the README at: https://github.com/intridea/omniauth

## Auth Hash

Here's an example Auth Hash available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'mixi',
  :uid => '1234567',
  :info => {
    :name => 'Yoichiro Tanaka',
    :first_name => 'Yoichiro',
    :last_name => 'Tanaka',
    :description => 'I am an engineer. And, ...',
    :location => 'Hasuda-shi, Saitama pref.',
    :nickname => 'Yoichiro',
    :urls => {
      :profile => 'http://mixi.jp/show_friend.pl?uid=1234567'
    },
    :image => 'https://profile.img.mixi.jp/1234567.jpg'
  },
  credentials => {
    :token => 'ABCDEFG...', # OAuth 2.0 access_token, which you may wish to store
    :refresh_token => 'HIJKLMN...',
    :expires_at => 1353854879, # when the access token expires (it always will)
    :expires => true
  },
  :extra => {
    :raw_info => {
      :addresses => [{
        :region => 'Saitama pref.',
        :type => 'location',
        :locality => 'Hasuda-shi'
      }],
      :thumbnailUrl => 'https://profile.img.mixi.jp/1234567.jpg',
      :aboutMe => 'I am an engineer. And, ...',
      :name => {
        :givenName => 'Yoichiro',
        :familyName => 'Tanaka'
      },
      :id => '1234567',
      :profileUrl => 'http://mixi.jp/show_friend.pl?uid=1234567',
      :displayName => 'Yoichiro'
    }
  }
}
```

The precise information available may depend on the permissions which you request.

## How To Launch Example

This project includes an example application to try OmniAuth-mixi quickly. You can launch the example by the following commands:

    $ cd example
    $ bundle install
    $ CLIENT_ID=[consumer_key] CLIENT_SECRET=[consumer_secret] rackup

Of course, you have to replace the two parameters `[consumer_key]` and `[consumer_secret]` to them issued for your application.

And, open http://localhost:9292/ in your browser, then you will see the authentication and authorization page of mixi.

## Supported Rubies

OmniAuth mixi is tested under 1.8.7, 1.9.2, 1.9.3 and JRuby.

[![CI Build
Status](https://secure.travis-ci.org/yoichiro/omniauth-mixi.png)](http://travis-ci.org/yoichiro/omniauth-mixi)
[![Dependency Status](https://gemnasium.com/yoichiro/omniauth-mixi.png)](https://gemnasium.com/yoichiro/omniauth-mixi)

## License

Copyright (c) 2012 by Yoichiro Tanaka

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.