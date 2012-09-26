require 'rails/generators'
require 'pp'
require 'json'
require 'faraday'
class DailycredGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  CLIENT_ID_DEFAULT = 'YOUR_CLIENT_ID'
  CLIENT_SECRET_DEFAULT = 'YOUR_SECRET_KEY'

  argument :client_id, :type => :string, :default => CLIENT_ID_DEFAULT, :banner => 'dailycred_client_id'
  argument :secret_key, :type => :string, :default => CLIENT_SECRET_DEFAULT, :banner => 'dailycred_secret_key'

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
    # copy initializer
    template "omniauth.rb", "config/initializers/omniauth.rb"
    # get client info from login if they didnt specify info
    if @client_id == CLIENT_ID_DEFAULT
      get_info
    end
    # application controller
    insert_into_file "app/controllers/application_controller.rb", APP_CONTROLLER_LINES, :after => /class ApplicationController\n|class ApplicationController .*\n/
    # add user_model
    copy_file "user.rb", "app/models/user.rb"
    # session_controller
    copy_file "migration_create_user.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_users.rb"
    # config/routes
    inject_into_file "config/routes.rb", APP_ROUTES_LINES, :after => ".draw do\n"
  end

  private

  def get_info first=true
    if first
      puts "Please insert your dailycred credentials. You must sign up for a free account at "+
        "http://www.dailycred.com. This is to automatically configure your api keys. If you wish to skip, enter 'n' as your email."
    else
      puts "Invalid email and password. Try again or type 'n' to skip."
    end
    #ssl opts
    # $stderr.puts 'getting input'
    input = get_input
    email, password = input[0], input[1]
    # $stderr.puts 'got input'
    return if email == "n"
    ssl_opts = {}
    if File.exists?('/etc/ssl/certs')
      ssl_opts = { :ca_path => '/etc/ssl/certs'}
    end
    if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')
      ssl_opts = { :ca_file => '/opt/local/share/curl/curl-ca-bundle.crt' }
    end
    # url = "https://www.dailycred.com"
    # url = "http://localhost:9000"
    # staging server for a very short time
    url = "http://ec2-72-44-40-55.compute-1.amazonaws.com:9000"
    connection = Faraday::Connection.new url, :ssl => ssl_opts
    params = {
      :login => email,
      :pass => password,
      :client_id => "dailycred"
    }
    response = connection.post("user/api/signin.json", params)
    json = JSON.parse(response.body)
    if !json["worked"]
      # wrong password
      p ''
      get_info false
    end
    access_token = json["access_token"]
    response = connection.post("graph/clientinfo.json", :access_token => access_token)
    json = JSON.parse(response.body)
    if !json["worked"]
      p "There was an error retrieving your account information. Please manually configure your API keys in config/initializers/omniauth.rb"
      return
    end
    @client_id = json["clientId"]
    @secret_key = json["clientSecret"]
    gsub_file("config/initializers/omniauth.rb", /YOUR_CLIENT_ID/, @client_id) if @client_id
    gsub_file("config/initializers/omniauth.rb", /YOUR_SECRET_KEY/, @secret_key) if @secret_key
  end

  def get_input
    puts ''
    print "Email:"
    email = gets.chomp
    return email, nil if email == "n"
    stty_settings = %x[stty -g]
    print 'Password: '
    begin
      %x[stty -echo]
      password = gets.chomp
    ensure
      %x[stty #{stty_settings}]
    end
    p ''
    return email, password
  end

  private

  def show obj
    $stderr.puts obj
  end


end
