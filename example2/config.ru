require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-dailycred'

class App < Sinatra::Base
  get '/' do
    user = request.env['omniauth.auth']
    puts user
    "<a href='/auth/dailycred'>Login</a>#{!user.nil? ? "hello #{user.email}" : ""}"
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end
  
  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :dailycred, 'd3637864-38b3-4ffd-a989-37722907d816', '1e2a49a4-ff88-413b-b1dd-8cff62725f00-36183932-ad11-4825-8596-7e634d679cbd'
end

run App.new