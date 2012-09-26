# Dailycred

## Introduction

The Dailycred ruby gem is everything you need to get off the ground running with robust authentication. It includes an [omniauth](https://github.com/intridea/omniauth) provider and a generator to create necessary models and controllers. The generated authentication structure is inspired by [nifty-generators](https://github.com/ryanb/nifty-generators). To get started using Dailycred with Ruby on Rails, the first thing you need to do is add the dailycred gem to your gemfile:

    gem 'dailycred'

Make sure you've signed up for Dailycred, and head over to your [settings](https://www.dailycred.com/admin/settings) page to get your API keys. Once you've done that, head back to the command line and run:

    bundle
    rails g dailycred
    rake db:migrate

Thats it! You've successfully added authentication to your app, and you can start signing up users. Run `rails s` to start your
    server, and point your browser to [http://localhost:3000/auth](http://localhost:3000/auth) and you'll see a pre-built page with links to sign up.

Here's what the dailycred gem generates for you:

*   A few helper methods to `/app/controllers/application_controller.rb`.
*   An initializer file at `/config/initializers/omniauth.rb` which configures your dailycred API keys.
*   `/app/models/user.rb`, the User model.
*   A migration file to create the user table in your database.


While this is enough to get off the ground running with user authentication, this setup is meant to be lightweight and flexible, so feel free to tinker with
    any of the generated code to better match your needs.

## Authenticating

To protect a controller method from unauthorized users, use the 'authorize' helper method as a `before_filter`.

    #before_filter :authenticate, :except => [:index] #don't authenticate some
    #before_filter :authenticate, :only => [:create, :new] #only authenticate some
    before_filter :authenticate #all methods

There are a few other helper methods available:

#### current_user

Returns the current logged in user or nil. Example usage:

    if !current_user.nil?
      redirect_to :controller => 'welcome', :action => 'thanks'
    end

#### dailycred

A helper for instantiating a dailycred client instance. Use as a `before_filter` to load a @dailycred instance variable, or just use it as a helper method. Example usage:

As a before filter:

    before_filter :dailycred

    def index
        @dailycred.event(current_user.uid, "New Task", @task.name)
    end

or just as a helper

    def index
        dailycred.event(current_user.uid, "New Task", @task.name)
    end

#### login_path

A helper for linking to the authentication url. Usage:

    <%= link_to 'sign up', login_path %>
    # => <a href="/auth/dailycred">sign up</a>

#### Logging out

To logout a user, simply send them to `/auth/logout`.

    <%= link_to 'logout', logout_path %>
    # => <a href="/auth/logout">logout</a>

#### Tagging a User

Dailycred provides the ability to 'tag' users, whether for reference in analytics or any other reason. Note that this is a very simple 'tagging' system, and not something you should use for dynamic tagging situations in your application.

    @user.tag 'awesome'
    @user.untag 'awesome'

#### Firing Events

You can also fire events tied to a specific user - this is helpful for goal tracking and tying actions to a specific user in analytics. We already fire many events for when a user signs up, resets a password, and much more, but you can also use the event system for something more specific for your application.

    # user#fire_event(key, value)
    @user.fire_event 'task added', @task.name

#### Testing Controllers

Testing controllers that have the `authenticate` before filter is easy:

    # with mocha
    @controller.expects(:current_user).returns(@user)

See `dummy/test/functional/post_controller_test.rb` for an example.

#### Dailycred API

For reference, have a look at the [annotated source code.](https://www.dailycred.com/public/docs/ruby/lib/dailycred.html)

For all API calls, you must first initalize a Dailycred client:

    @dailycred = Dailycred.new "YOUR_CLIENT_ID", "your_secret_key", opts

Where opts is an optional hash for passing options. After initializing your client, you can create events as well as tag and untag users:

    @dailycred.event(current_user.uid, "New Task", @task.name) # user_id, key, value
    @dailycred.tag(current_user.uid, "Failed Checkout") # user_id, key
    @dailycred.untag(current_user.uid, "Failed Checkout") # user_id, key


#### Configuration

To specify where users should be redirected after authentication actions, setup configure an `after_auth` property on a `Rails.configuration.DAILYCRED_OPTIONS` variable. Example:

    # configure where users should be redirected after authentication
    #
    # Rails.configuration.DAILYCRED_OPTIONS = {
    #   :after_auth => '/hello', #after login
    #   :after_unauth => '/goodbye' #after logout
    # }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

![](https://www.dailycred.com/dc.gif?client_id=dailycred&title=rails_repo "dailycred")

