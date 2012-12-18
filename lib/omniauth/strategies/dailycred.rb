require 'omniauth-oauth2'
require 'faraday'
require 'net/https'
require 'json'
require 'pp'

# #The Dailycred Omniauth Strategy
module OmniAuth
  module Strategies
    class Dailycred < OmniAuth::Strategies::OAuth2

      # default options
      option :client_options, {
        :site => "https://www.dailycred.com",
        :authorize_url => '/connect',
        :token_url => '/oauth/access_token'
      }

      # allows parameters to be passed through
      AUTH_PARAMS = ["action","identity_provider","referrer", "access_token"]

      option :authorize_options, OmniAuth::Strategies::Dailycred::AUTH_PARAMS

      uid { user['uid'] }

      info do
        user
      end

      alias :old_request_phase :request_phase


      def authorize_params
        super.tap do |params|
          params[:state] ||= {}
        end
      end

      # this step allows auth_params to be added to the url
      def request_phase
        p session['omniauth.state']
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

      # This is the phase where the gem calls me.json, which returns information about the user
      def user
        return @duser if !@duser.nil?
        connection = Faraday::Connection.new options.client_options[:site], :ssl => options.client_options[:ssl]
        response = connection.get("/graph/me.json?access_token=#{access_token.token}")
        json = JSON.parse(response.body)
        pp json if options[:verbose]
        @duser = {'token' => access_token.token}
        @duser['provider'] = 'dailycred'
        @duser['uid'] =  json['id'] || json['user_id']
        json.each do |k,v|
          @duser[k] = v
        end
        json["identities"].each do |k, v|
          @duser[k] = v
          @duser[k][:access_token] = json["access_tokens"][k]
        end if !json["identities"].nil?
        pp @duser if options[:verbose]
        created = json['created'] / 1000
        @duser['created'] = DateTime.strptime(created.to_s, '%s')
        @duser.delete("id")

        @duser
      end

    end
  end
end