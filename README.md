# Omniauth::Dailycred

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-dailycred'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-dailycred

## Usage

bash

    rails g controller sessions
    rails g model user provider:string uid:string email:string
    rake db:migrate
    touch app/views/sessions/hello.html.erb
    touch config/initializers/omniauth.rb
    rm public/index.html


gemfile
  
    gem 'omniauth'
    gem 'omniauth-oauth2'
    gem 'omniauth-dailycred'

config/initializers/omniauth.rb

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider 'dailycred', YOUR_APP_KEY, YOUR_SECRET_KEY
    end


routes.rb (make sure you delete the file /public/index.html)

    match "/auth/:provider/callback" => "sessions#create"
    match "/signout" => "sessions#destroy", :as => :signout
    root :to => "sessions#hello"


sessions_controller.rb

    def create
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Signed in!"
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => "Signed out!"
    end

    def hello
      
    end


models/user.rb

    def self.create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
      end
    end


application_controller.rb

    helper_method :current_user

    private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end


app/views/sessions/hello.html.erb

    <% if current_user %>
      Welcome <%= current_user.email %>!
      <%= link_to "Sign Out", signout_path %>
    <% else %>
      <%= link_to "Sign in", "/auth/dailycred" %>
    <% end %>


## SSL Error

You may get an error such as the following:

    Faraday::Error::ConnectionFailed (SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed):

If that is the case, consider following fixes explained [here](https://github.com/technoweenie/faraday/wiki/Setting-up-SSL-certificates). If that doesn't work, consider adding the following line: 

    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

to the top of config/initializers/omniauth.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

omniauth-dailycred

OmniAuth adapter for dailycred using their OAuth2 Strategy
