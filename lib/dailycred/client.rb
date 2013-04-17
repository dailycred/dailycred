module Dailycred
  class Client
    require 'faraday'
    attr_accessor :client_id, :secret_key, :options, :url

    URL = "https://www.dailycred.com"

    ROUTES = {
      :signup => "/user/api/signup.json",
      :login  => "/user/api/signin.json"
    }

    # Initializes a dailycred object
    #
    # - @param [String] client\_id the client's daiycred client id
    # - @param [String] secret\_key the clients secret key
    # - @param [Hash] opts a hash of options
    def initialize(client_id, secret_key="", opts={})
      @client_id = client_id
      @secret_key = secret_key
      @options = opts
      opts[:client_options] ||= {}
      @url = opts[:client_options][:site] || Dailycred::Client::URL
    end

    # Generates a Dailycred event
    #
    # - @param [String] user_id the user's dailycred user id
    # - @param [String] key the name of the event type
    # - @param [String] val the value of the event (optional)
    def event(user_id, key, val="")
      opts = {
        :key => key,
        :valuestring => val,
        :user_id => user_id
      }
      post "/admin/api/customevent.json", opts
    end

    # Tag a user in dailycred
    #
    # - @param [String] user_id the user's dailycred user id
    # - @param [String] tag the desired tag to add
    def tag(user_id, tag)
      opts = {
        :user_id => user_id,
        :tag => tag
      }
      post "/admin/api/user/tag.json", opts
    end

    # Untag a user in dailycred
    # (see #tag)
    def untag(user_id, tag)
      opts = {
        :user_id => user_id,
        :tag => tag
      }
      post "/admin/api/user/untag.json", opts
    end

    # Send a reset password email
    #
    # - @param [string] user the user's email or username
    def reset_password(user)
      opts = {
        :user => user
      }
      post "/password/api/reset", opts
    end

    # A wildcard for making any post requests to dailycred.
    # client_id and client_secret are automatically added to the request
    #
    # - @param [string] url
    # - @param [hash] opts
    # - @param [boolean] secure whether the client_secret should be passed. Defaults to true
    def post(url, opts, secure=true)
      opts.merge! base_opts(secure)
      response = get_conn.post url, opts
    end

    private

    def ssl_opts
      opts = {}
      if @options[:client_options] && @options[:client_options][:ssl]
        opts[:ssl] = @options[:client_options][:ssl]
      elsif Rails.configuration.respond_to? "DAILYCRED_OPTIONS"
        opts[:ssl] = Rails.configuration.DAILYCRED_OPTIONS[:client_options][:ssl]
      end
      opts
    end

    def base_opts secure=true
      opts = {:client_id => @client_id}
      opts[:client_secret] = @secret_key if secure
      opts
    end

    def get_conn
      Faraday::Connection.new @url, ssl_opts
    end
  end

end