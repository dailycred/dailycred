# Dailycred

## Installation

Add this line to your application's Gemfile: 

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-dailycred

## Usage

bash
    
    rails g dailycred YOUR_CLIENT_ID YOUR_SECRET_KEY
    rake db:migrate

This will generate everything you need to get going with authentication, including a user model, session controller, omniauth initializer, javascript tracking code, and many helper variables. You will You can locate your API keys at [dailycred](https://www.dailycred.com/admin/settings/keys)

##### Authentication

Use the `:authenticate` helper to require a user to be signed in:

    before_filter :authenticate

The current user object can be located with `current_user`:

    # in posts_controller

    @posts = currrent_user.posts.all

##### Using only with Omniauth

If you already have omniauth set up and only want to use Dailycred as another OAuth provider, just add this line to your omniauth initializer file

    provider :dailycred, 'CLIENT_ID', 'SECRET_KEY'

##### Events

To fire an event to be logged in Dailycred:

    #in your controller

    before_filter :dailycred

    def create
      ...

      # after successfully saving the model:
      @dailycred.event(current_user.uid, 'Created Post', @post.name)

    end

## SSL Error

You may get an error such as the following:

    Faraday::Error::ConnectionFailed (SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed):

If that is the case, consider following fixes explained [here](https://github.com/technoweenie/faraday/wiki/Setting-up-SSL-certificates) or [here](http://martinottenwaelter.fr/2010/12/ruby19-and-the-ssl-error).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

omniauth-dailycred

OmniAuth adapter for dailycred using their OAuth2 Strategy
