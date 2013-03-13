# Dailycred

[![Build Status](https://secure.travis-ci.org/dailycred/dailycred.png?branch=master)](https://travis-ci.org/dailycred/dailycred)

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

#### login_path

A helper for linking to the authentication url.

    <%= link_to 'sign up', login_path %>
    # => <a href="/auth/dailycred">sign up</a>

#### logout_path

To logout a user, simply send them to `/auth/logout`.

    <%= link_to 'logout', logout_path %>
    # => <a href="/auth/logout">logout</a>
    
#### authenticate

To protect a controller method from unauthorized users, use the 'authorize' helper method as a `before_filter`.

    #before_filter :authenticate, :except => [:index] #don't authenticate some
    #before_filter :authenticate, :only => [:create, :new] #only authenticate some
    before_filter :authenticate #all methods

## Social Connect

To use a social sign-in service instead of email, and password, use `connect_path.`

    <%= link_to 'sign in with facebook', connect_path(:identity_provider => :facebook) %>

The `identity_provider` can be one of `facebook`, `google`, `twitter`, `disqus`, or `instagram`.

After a user has social connected, their social data is serialized into individual fields in the user model. The serialized object is the exact same as what the social provider's graph response returns. For example:

    p current_user.facebook
    # =>
    {
        "video_upload_limits" => {
            "length" => 1200.0,
            "size" => 1073741824.0
        },
        "locale" => "en_US",
        "link" => "http://www.facebook.com/joe.smith",
        "updated_time" => "2012-09-27T19:04:38+0000",
        "currency" => {
            "user_currency" => "USD",
            "currency_exchange" => 10.0,
            "currency_exchange_inverse" => 0.1,
            "currency_offset" => 100.0
        },
        "picture" => {
            "data" => {
                "url" => "http://profile.ak.fbcdn.net/hprofile-ak-ash4/370570_1039690812_2022945351_q.jpg",
                "is_silhouette" => false
            }
        },
        "id" => "1092609812",
        "third_party_id" => "cBLDKnqlfYlReV7Jo4yRAFB1a4I",
        "first_name" => "Joe",
        "username" => "jsmitty",
        "bio" => "shred the gnar.",
        "email" => "jsmitty@dailycred.com",
        "verified" => true,
        "name" => "Joe Smith",
        "last_name" => "Stoever",
        "gender" => "male",
        "access_token" =>"AAAFHsZAi9ddUBAKPMOKPDrmJlclwCoVHCfwflF5ZCyLZC70SOo0MPvj62lhHZAnV6jk8DEfBSjLtfcyC7Bx25a9CLphzoayv3EtvbE2tAQZDZD"
    }

You can also connect additional social accounts to an existing user:

    <%= link_to 'connect with facebook', connect_user(:facebook) %>

`connect_user` defaults to connecting the `current_user`, but you can explicitly connect any user:

    <%= link_to 'connect with google', connect_user(:google, @user) %>

---

##Helpers

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

#### Tagging a User

Dailycred provides the ability to 'tag' users, whether for reference in analytics or any other reason. Note that this is a very simple 'tagging' system, and not something you should use for dynamic tagging situations in your application.

    @user.tag 'awesome'
    @user.untag 'awesome'

#### Firing Events

You can also fire events tied to a specific user - this is helpful for goal tracking and tying actions to a specific user in analytics. We already fire many events for when a user signs up, resets a password, and much more, but you can also use the event system for something more specific for your application.

    # user#fire_event(key, value)
    @user.fire_event 'task added', @task.name

#### Building Referral URLs

To easily build referral URLs to track sharing amongst your users, use `referral_link(my_site)`, where *my_site* is the url that you wish referred users to be sent to.

    current_user.referral_link("http://www.mysite.com")

#### Testing Controllers

Testing controllers that have the `authenticate` before filter is easy:

    # with mocha
    @controller.stubs(:current_user).returns(@user)

See `dummy/test/functional/post_controller_test.rb` for an example.

#### Dailycred API

For reference, have a look at the [annotated source code.](https://www.dailycred.com/public/docs/ruby/lib/dailycred.html)

For all API calls, you must first initalize a Dailycred client:

    @dailycred = Dailycred.new "YOUR_CLIENT_ID", "your_secret_key", opts

Where opts is an optional hash for passing options. After initializing your client, you can create events as well as tag and untag users:

    @dailycred.event(current_user.uid, "New Task", @task.name) # user_id, key, value
    @dailycred.tag(current_user.uid, "Failed Checkout") # user_id, key
    @dailycred.untag(current_user.uid, "Failed Checkout") # user_id, key


#### Persona Login

1. Set your `persona audience` in your [dailycred identity provider settings](https://www.dailycred.com/admin/settings/identity-providers). This will be `http://{your-url}/auth/dailycred/callback`.
2. Make sure you have configured your `callback url` in your [dailycred app settings](https://www.dailycred.com/admin/settings)
3. In `config/omniauth.rb`, configure your middleware options to include your persona audience:

    Rails.configuration.DAILYCRED_OPTIONS = {
        middleware: {
            persona_audience = "http://{your-url}/auth/dailycred/callback"
        }
    }

4. In your javascript, call `personaLogin()`.

    $(document).ready(function(){
        $('.persona-login').click(function(){
            personaLogin();
        })
    })

5. Your user will be redirected to your [persona.org](https://persona.org) to login. If successful, your user will be redirected to your OAuth callback URL and be logged in.

For more details, visit our [persona documentation](https://www.dailycred.com/docs/persona)


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

