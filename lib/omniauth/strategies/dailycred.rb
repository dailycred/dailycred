require 'omniauth-oauth2'
require 'faraday'
require 'net/https'
require 'json'
require 'pp'

module OmniAuth
  module Strategies
    class Dailycred < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :site => "https://www.dailycred.com",
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/access_token'
      }

      ATTRIBUTES = ["email", "username", "created", "verified", "admin", "referred_by", "tags", "referred"]
      AUTH_PARAMS = ["action"]

      option :authorize_options, OmniAuth::Strategies::Dailycred::AUTH_PARAMS

      uid { user['id'] }

      info do
        user
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
        connection = Faraday::Connection.new options.client_options[:site], :ssl => {
          :ca_file => "/opt/local/share/curl/curl-ca-bundle.crt"
        }
        response = connection.get("/graph/me.json?access_token=#{access_token.token}")
        json = JSON.parse(response.body)
        pp json
        @duser = {'token' => access_token.token}
        @duser['provider'] = 'dailycred'
        @duser['uid'] = json['id']
        OmniAuth::Strategies::Dailycred::ATTRIBUTES.each do |attr|
          @duser[attr] = json[attr]
        end
        if !json["FACEBOOK"].nil?
          @duser['facebook'] = json["FACEBOOK"]["members"]
        end
        pp @duser

        @duser
      end

    end
  end
end