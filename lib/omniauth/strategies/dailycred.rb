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

      ATTRIBUTES = ["email", "id", "username", "created", "verified", "admin", "referred_by", "tags", "referred"]
      AUTH_PARAMS = ["action"]

      option :authorize_options, OmniAuth::Strategies::Dailycred::AUTH_PARAMS
      
      uid { user['id'] }
      
      info do
        infos = {}
        OmniAuth::Strategies::Dailycred::ATTRIBUTES.each do |attribute|
          infos[attribute] = user[attribute]
        end
        infos
      end
      
      alias :old_request_phase :request_phase


      def authorize_params
        super.tap do |params|
          params[:state] ||= {}
        end
      end

      def request_phase 
        OmniAuth::Strategies::Dailycred::AUTH_PARAMS.each do |param|
          val = session['omniauth.params'][param]
          if val && !val.empty?
            options[:authorize_params] ||= {}
            options[:authorize_params].merge!(param => val)
          end
        end
        old_request_phase
      end

      private

      def user
        return @duser if !@duser.nil?
        connection = Faraday::Connection.new 'https://www.dailycred.com', :ssl => {
          :ca_file => "/opt/local/share/curl/curl-ca-bundle.crt"
        }
        response = connection.get("/graph/me.json?access_token=#{access_token.token}")
        json = JSON.parse(response.body)
        @duser = {}
        OmniAuth::Strategies::Dailycred::ATTRIBUTES.each do |attr|
          @duser[attr] = json[attr]
        end

        @duser
      end
        
    end
  end
end