require 'rails'
module Dailycred

  class Engine < Rails::Engine

    initializer 'dailycred.setup', :after=>"dailycred" do |app|
      conf = Rails.configuration# alias for configuration
      if conf.respond_to? 'DAILYCRED_CLIENT_ID'
        id = conf.DAILYCRED_CLIENT_ID
        secret = conf.DAILYCRED_SECRET_KEY

        # setup omniauth options, can be overridden. ex:
        # Rails.application.DAILYCRED_OPTIONS = {
        #   :client_options => {
        #     :site => 'https://www.dailycred.com',
        #     :authorize_url => '/connect',
        #     :token_url => '/oauth/access_token'
        #   }
        # }
        if conf.respond_to? 'DAILYCRED_OPTIONS'
          opts = conf.DAILYCRED_OPTIONS
          opts[:client_options] ||= {}
          opts[:client_options][:ssl] = {}
        else
          opts = {:client_options => {:ssl => {}}}
          conf.DAILYCRED_OPTIONS = opts
        end

        if File.exists?('/etc/ssl/certs')
          opts[:client_options][:ssl][:ca_path] = '/etc/ssl/certs'
        end
        if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
          opts[:client_options][:ssl][:ca_file] = '/opt/local/share/curl/curl-ca-bundle.crt'
        end

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider :dailycred, id, secret, opts
        end

        Rails.application.config.middleware.use "Dailycred::Middleware", id

        ActiveSupport.on_load(:action_controller) do
          include Dailycred::Helpers
        end
      end
    end


  end

end