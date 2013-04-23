Dir[File.expand_path('../dailycred/*', __FILE__)].each { |f| require f }
require "omniauth/strategies/dailycred"