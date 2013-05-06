Feature: Creating an app with the dailycred generator

  Scenario: creating an app
    Given I run `rails new tmp_app -T`
    And I cd to "tmp_app"
    And a file named "Gemfile" with:
    """
    source "http://rubygems.org"
    gem 'rails'
    gem 'sqlite3'
    gem 'dailycred', :path => '../../../'
    group :test, :development do
      gem "rspec-rails", "~> 2.0"
    end
    group :assets do
      gem 'sass-rails',   '~> 4.0.0.beta1'
      gem 'coffee-rails', '~> 4.0.0.beta1'
      gem 'uglifier', '>= 1.0.3'
    end
    gem 'jquery-rails'
    gem 'turbolinks'
    """
    Then I successfully run `bundle install`
    And I successfully run `rails generate dailycred:install`
    And I successfully run `rails generate dailycred:controllers`
    And I successfully run `rails generate rspec:install`
    And I successfully run `rake db:migrate`
    And a file named "config/initializers/omniauth.rb" with:
    """
    Rails.configuration.DAILYCRED_CLIENT_ID = "37a067dd-3fef-4efd-909a-38b8081c5867"
    Rails.configuration.DAILYCRED_SECRET_KEY = "b622f8a7-fa92-4fe8-bb74-b5bad5db79d3-817ddff2-6fa1-4499-ae47-69ea0d4c5c44"
    Rails.configuration.DAILYCRED_OPTIONS = {
      :after_auth => '/auth', #after login
      :after_unauth => '/' #after logout
    }
    """
    And a file named "spec/controllers/users_controller_spec.rb" with:
    """
    require "spec_helper"

    describe Dailycred::UsersController do
      describe "GET #reset_password" do
        it "responds successfully with the right parameters" do
          get(:reset_password, {:use_route => :auth, user: "test@test.com"})
          flash[:notice].should match("Your password has been reset.")
        end
        it "fails without the :user parameter" do
          get(:reset_password, :use_route => :auth)
          flash[:notice].should match("Please enter your email or password")
        end
      end
    end
    """
    When I successfully run `rake spec`