require 'rails/generators'
require 'test_helper'
module Dailycred
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      CLIENT_ID_DEFAULT = 'YOUR_CLIENT_ID'
      CLIENT_SECRET_DEFAULT = 'YOUR_SECRET_KEY'

      argument :client_id, :type => :string, :default => CLIENT_ID_DEFAULT, :banner => 'dailycred_client_id'
      argument :secret_key, :type => :string, :default => CLIENT_SECRET_DEFAULT, :banner => 'dailycred_secret_key'
      class_option :bootstrap, :type => :boolean, :default => true, 
        :description => "Indicates whether you want to generate the user model (with migration)
        and mount the engine's sessions_controller.
        Use --skip-bootstrap if you want are adding this to project that already has authentication
        and you only want to use the Omniauth adapter and helper methods."
      

      APP_ROUTES_LINES =<<-EOS
      mount Dailycred::Engine => '/auth', :as => 'dailycred_engine'
      EOS

      APP_CONTROLLER_LINES =<<-EOS
      helper_method :current_user

      private

      # helper method for getting the current signed in user
      def current_user
        begin
          @current_user || User.find(session[:user_id]) if session[:user_id]
        rescue
          nil
        end
      end
      EOS

      def install
        puts 'installing'
        # copy initializer
        template "omniauth.rb", "config/initializers/omniauth.rb"
        # get client info from login if they didnt specify info
        puts "Please manually configure your API keys in config/initializers/omniauth.rb"
        if options.bootstrap?
          # application controller
          insert_into_file "app/controllers/application_controller.rb", APP_CONTROLLER_LINES, :after => /class ApplicationController\n|class ApplicationController .*\n/
          # user model
          copy_file "user.rb", "app/models/user.rb"
          # user migration
          copy_file "migration_create_user.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_users.rb"
          # confiffg/routes
          inject_into_file "config/routes.rb", APP_ROUTES_LINES, :after => ".draw do\n"
        else
          puts "Make sure you implement your omniauth callback. For directions visit https://github.com/intridea/omniauth#integrating-omniauth-into-your-application"
        end
      end


    end
  end
end