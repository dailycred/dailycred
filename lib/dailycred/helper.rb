module Dailycred
  module Helpers

    # use as a before_filter to only allow signed in users
    # example:
    #   before_filter :authenticate
    def authenticate
      redirect_to_unauth unless current_user
    end

    # helper method for getting an instance of dailycred
    # example:
    #   dailycred.tagUser "user_id", "tag"
    #
    # for more documentation, visit https://www.dailycred.com/api/ruby
    def dailycred
      config = Rails.configuration
      @dailycred ||= Dailycred::Client.new(config.DAILYCRED_CLIENT_ID, config.DAILYCRED_SECRET_KEY, config.DAILYCRED_OPTIONS)
    end

    # when making oauth calls, we may need to redirect to our oauth callback url
    # make sure we have the correct state passed back and forth
    def set_state
      @state = session["omniauth.state"] = SecureRandom.hex(24)
    end

    def login_path(params={})
      "/auth/dailycred"
    end

    def connect_path(params)
      url = "#{request.protocol}#{request.host_with_port}/auth/dailycred"
      p = []
      params.each do |k,v|
        p << "#{k}=#{v.to_s}"
      end
      url += "?" if p.size > 0
      url += p.join("&")
    end

    def connect_user provider, user=nil
      if user.nil?
        user = current_user
      end
      connect_path(access_token: user.token, identity_provider: provider)
    end

    def redirect_to_auth opts={}
      conf = Rails.configuration.DAILYCRED_OPTIONS
      path = !conf[:after_auth].nil? ? conf[:after_auth] : dailycred_engine.auth_info_path
      redirect_to path, opts
    end

    def redirect_to_unauth opts = {}
      conf = Rails.configuration.DAILYCRED_OPTIONS
      path = !conf[:after_unauth].nil? ? conf[:after_unauth] : dailycred_engine.auth_info_path
      redirect_to path, opts
    end
  end
end