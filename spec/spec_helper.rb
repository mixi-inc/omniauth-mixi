$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

if RUBY_VERSION >= '1.9.0'
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'rack/test'
require 'webmock/rspec'

require 'omniauth'
require 'omniauth-mixi'

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end

