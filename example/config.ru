require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-mixi'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/mixi'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :mixi, ENV['CLIENT_ID'], ENV['CLIENT_SECRET']
end

run App.new
