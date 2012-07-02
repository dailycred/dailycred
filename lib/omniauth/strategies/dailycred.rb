require 'omniauth-oauth2'
require 'faraday'
require 'json'

module OmniAuth
  module Strategies
    class Dailycred < OmniAuth::Strategies::OAuth2
      
      option :client_options, {
        :site => 'http://localhost:9000',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/api/token.json'
      }
      
      uid { user['id'] }
      
      info do
        temp_user = user
        puts temp_user
        puts "======"
        {
          'email'   => temp_user['emai'],
          'username'=> temp_user['username'],
          'created' => temp_user['created']
        }
      end
      
      private
      def user
        conn = Faraday.new(:url => 'http://localhost:9000') do |faraday|
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
        
        @user ||= duser
      end
        
    end
  end
end