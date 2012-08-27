class DailycredGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :client_id, :type => :string, :default => 'YOUR_CLIENT_ID', :banner => 'dailycred_client_id'
  argument :secret_key, :type => :string, :default => 'YOUR_SECRET_KEY', :banner => 'dailycred_secret_key'

  APP_NAME = Rails.application.class.parent.name

  APP_ROUTES_LINES =<<-EOS
  match '/auth/:provider/callback' => 'sessions#create'
  match "/logout" => "sessions#destroy", :as => :logout
  match "/auth" => "sessions#info", :as => :auth
  EOS

  APP_CONTROLLER_LINES =<<-EOS
  helper_method :current_user, :login_path, :dailycred

  private

  def current_user
    begin
      @current_user || User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def authenticate
    redirect_to :root unless current_user
  end

  def login_path
    "/auth/dailycred"
  end

  def dailycred
    config = Rails.configuration
    @dailycred ||= Dailycred.new(config.dailycred_client_id, config.dailycred_secret_key)
  end
  EOS

  def install
    dailycred_ascii =<<-EOS
    //*****
    //*****
    //*****
    //*****
    //*****
    //*****    Thanks for using dailycred!
    //*****
    //*****
    //*****
    //*****
    //*****
    EOS
    print dailycred_ascii
    # copy initializer
    template "omniauth.rb", "config/initializers/omniauth.rb"
    # session_controller
    copy_file "sessions_controller.rb", "app/controllers/sessions_controller.rb"
    # application controller
    inject_into_class "app/controllers/application_controller.rb", ApplicationController, APP_CONTROLLER_LINES
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
