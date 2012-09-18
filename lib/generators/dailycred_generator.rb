class DailycredGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :client_id, :type => :string, :default => 'YOUR_CLIENT_ID', :banner => 'dailycred_client_id'
  argument :secret_key, :type => :string, :default => 'YOUR_SECRET_KEY', :banner => 'dailycred_secret_key'

  APP_NAME = Rails.application.class.parent.name

  APP_ROUTES_LINES =<<-EOS
  match '/auth/:provider/callback' => 'sessions#create'
  match "/logout" => "sessions#destroy", :as => :logout
  match "/auth" => "sessions#info", :as => :auth_info
  match "/auth/dailycred", :as => :auth
  match "/auth/failure" => "sessions#failure"
  EOS

  APP_CONTROLLER_LINES =<<-EOS
  helper_method :current_user, :login_path, :dailycred, :signup_path

  private

  # helper method for getting the current signed in user
  def current_user
    begin
      @current_user || User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  # use as a before_filter to only allow signed in users
  # example:
  #   before_filter :authenticate
  def authenticate
    redirect_to auth_path unless current_user
  end

  # helper method for getting an instance of dailycred
  # example:
  #   dailycred.tagUser "user_id", "tag"
  #
  # for more documentation, visit https://www.dailycred.com/api/ruby
  def dailycred
    config = Rails.configuration
    @dailycred ||= Dailycred.new(config.DAILYCRED_CLIENT_ID, config.DAILYCRED_SECRET_KEY, config.dc_options)
  end
  EOS

  APP_HELPER_LINES = <<-EOS
  def connect_path(provider)
    url = "/auth/dailycred?identity_provider=#{provider.to_s}"
    url += "&referrer=#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
  EOS

  def install
    dailycred_ascii =<<-EOS
    *****
    *****
    *****
    *****
    *****
    *****    Thanks for using dailycred!
    *****
    *****
    *****
    *****
    *****
    EOS
    print dailycred_ascii
    # copy initializer
    template "omniauth.rb", "config/initializers/omniauth.rb"
    # session_controller
    copy_file "sessions_controller.rb", "app/controllers/sessions_controller.rb"
    # application controller
    inject_into_class "app/controllers/application_controller.rb", ApplicationController, APP_CONTROLLER_LINES
    # application helper
    inject_into_class "app/helpers/application_helper.rb", ApplicationController, APP_HELPER_LINES
    # add user_model
    copy_file "user.rb", "app/models/user.rb"
    # session_controller
    copy_file "migration_create_user.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_users.rb"
    # auth page
    copy_file "info.html.erb", "app/views/sessions/info"
    # config/routes
    inject_into_file "config/routes.rb", APP_ROUTES_LINES, :after => "#{APP_NAME}::Application.routes.draw do\n"
  end
end
