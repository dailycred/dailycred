require "omniauth-dailycred/version"
require "omniauth/strategies/dailycred"
require "middleware"

class Dailycred

  attr_accessor :client_id, :secret_key

  def initialize(client_id, secret_key="")
    @client_id = client_id
    @secret_key = secret_key
  end

  def event(user_id, key, val="")
    connection = Faraday::Connection.new 'https://www.dailycred.com', :ssl => { :ca_file => "/opt/local/share/curl/curl-ca-bundle.crt" }
    opts = {
      :client_id => client_id,
      :client_secret => secret_key,
      :key => key,
      :valuestring => val,
      :user_id => user_id
    }
    connection.post "/admin/api/customevent.json", opts
  end

end

module Omniauth
  module Dailycred
    # Your code goes here...
  end
end
