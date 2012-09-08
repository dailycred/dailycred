require "omniauth-dailycred/version"
require "omniauth/strategies/dailycred"
require "middleware/middleware"

class Dailycred

  attr_accessor :client_id, :secret_key, :options, :url

  URL = "https://www.dailycred.com"

  ROUTES = {
    :signup => "/user/api/signup.json",
    :login  => "/user/api/signin.json"
  }

  # Initializes a dailycred object
  # @param [String] client_id the client's daiycred client id
  # @param [String] secret_key the clients secret key
  # @param [Hash] opts a hash of options
  def initialize(client_id, secret_key="", opts={})
    @client_id = client_id
    @secret_key = secret_key
    @options = opts
    opts[:client_options] ||= {}
    @url = opts[:client_options][:site] || Dailycred::URL
  end

  # Generates a Dailycred event
  # @param [String] user_id the user's dailycred user id
  # @param [String] key the name of the event type
  # @param [String] val the value of the event (optional)
  def event(user_id, key, val="")
    opts = {
      :key => key,
      :valuestring => val,
      :user_id => user_id
    }
    post "/admin/api/customevent.json", opts
  end

  # Tag a user in dailycred
  # @param [String] user_id the user's dailycred user id
  # @param [String] tag the desired tag to add
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

  def post(url, opts)
    opts.merge! base_opts
    response = get_conn.post url, opts
  end

  private

  def ssl_opts
    opts = {}
    if @options[:client_options] && @options[:client_options][:ssl]
      opts[:ssl] = @options[:client_options][:ssl]
    end
    opts
  end

  def base_opts
    {
      :client_id => @client_id,
      :client_secret => @secret_key
    }
  end

  def get_conn
    Faraday::Connection.new @url, ssl_opts
  end
end
