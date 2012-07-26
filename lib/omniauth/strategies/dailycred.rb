require 'omniauth-oauth2'
require 'faraday'
require 'json'

module OmniAuth
  module Strategies
    class Dailycred < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://www.dailycred.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/api/token.json'
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
        conn = Faraday.new(:url => 'https://www.dailycred.com') do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
        
        response = conn.post '/oauth/api/me.json', {:access_token => access_token.token}
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