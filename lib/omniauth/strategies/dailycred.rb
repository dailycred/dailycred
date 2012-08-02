require 'omniauth-oauth2'
require 'faraday'
require 'net/https'
require 'json'

module OmniAuth
  module Strategies
    class Dailycred < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://www.dailycred.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/access_token'
      }
      
      uid { user['id'] }
      
      info do
        {
          'email'   => user['email'],
          'username'=> user['username'],
          'created' => user['created']
        }
      end
      
      private
      def user
        connection = Faraday::Connection.new 'https://www.dailycred.com', :ssl => {
          :ca_file => "/opt/local/share/curl/curl-ca-bundle.crt"
        }
        response = connection.get("/graph/me.json?access_token=#{access_token.token}")
        p response.body
        p JSON.parse(response.body)
        json = JSON.parse(response.body)
        duser = {}
        duser['email']   = json['email']
        duser['id']      = json['id']
        duser['username']= json['username']
        duser['created'] = json['created']
        
        duser
      end
        
    end
  end
end