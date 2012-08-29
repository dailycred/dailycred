$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'rspec'
require 'rack/test'
require 'omniauth'
require 'dailycred'

Dir[File.expand_path('../support/**/*', __FILE__)].each { |f| require f }

require 'omniauth/strategies/dailycred_spec'
require 'support/shared_examples'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end