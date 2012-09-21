require 'rails/generators'
# require 'mocha'
require_relative "../lib/generators/dailycred_generator.rb"
class GeneratorTest < Rails::Generators::TestCase
  tests DailycredGenerator
  destination File.expand_path("./tmp/myproject", File.dirname(__FILE__))

  setup :prepare_destination

  setup do
    # Must set before requiring generator libs.
    TMP_ROOT = File.dirname(__FILE__) + "/tmp" unless defined?(TMP_ROOT)
    PROJECT_NAME = "myproject" unless defined?(PROJECT_NAME)
    app_root = File.join(TMP_ROOT, PROJECT_NAME)
    if defined?(APP_ROOT)
      APP_ROOT.replace(app_root)
    else
      APP_ROOT = app_root
    end
    if defined?(RAILS_ROOT)
      RAILS_ROOT.replace(app_root)
    else
      RAILS_ROOT = app_root
    end
    Dir.mkdir("#{RAILS_ROOT}/config") unless File.exists?("#{RAILS_ROOT}/config")
    File.open("#{RAILS_ROOT}/config/routes.rb", 'w') do |f|
      f.puts "ActionController::Routing::Routes.draw do\n\nend"
    end
    Dir.mkdir("#{RAILS_ROOT}/app") unless File.exists?("#{RAILS_ROOT}/app")
    Dir.mkdir("#{RAILS_ROOT}/app/controllers") unless File.exists?("#{RAILS_ROOT}/app/controllers")
    File.open("#{RAILS_ROOT}/app/controllers/application_controller.rb", 'w') do |f|
      f.puts "class ApplicationController < ActionController::Base\n\nend"
    end
    Dir.mkdir("#{RAILS_ROOT}/app/helpers")
    File.open("#{RAILS_ROOT}/app/helpers/application_helper.rb", 'w') do |f|
      f.puts "module ApplicationHelper\n\nend"
    end
  end

  teardown do
    FileUtils.rm_rf "#{RAILS_ROOT}/app"
    FileUtils.rm_rf "#{RAILS_ROOT}/config"
    FileUtils.rm_rf "#{RAILS_ROOT}/db"
  end

  test "generator works with input" do
    test_generator ["aaa","bbb"]
    assert_credentials "aaa", "bbb"
  end

  test "generator works with login" do
    generator_class.any_instance.stubs(:get_input).returns(["localtest@dailycred.com","password"])
    test_generator
    assert_credentials "e92e20bf-e0a4-49b4-8a82-ff1b65d80017", "9adf81a8-ce97-4bcb-9c1f-c09f5fc7b6b8-0d1a4553-496d-450e-80fd-9e8d0552a920"
  end

  private

  def test_generator args=[]
    run_generator args
    assert_file "config/initializers/omniauth.rb" do |config|
      assert_true config.include? "Rails.application.config.middleware.use"
      # assert_true config.include? 'Rails.configuration.DAILYCRED_CLIENT_ID = "YOUR_CLIENT_ID"'
      # assert_true config.include? 'Rails.configuration.DAILYCRED_SECRET_KEY = "YOUR_SECRET_KEY"'
    end

    assert_file "config/routes.rb", /(#{Regexp.escape('match "/auth/:provider/callback" => "sessions#create"')})/
    assert_file "config/routes.rb", /(#{Regexp.escape('match "/logout" => "sessions#destroy", :as => :logout')})/
    assert_file "config/routes.rb", /(#{Regexp.escape('match "/auth" => "sessions#info", :as => :auth')})/
    assert_file "config/routes.rb", /(#{Regexp.escape('match "/auth/dailycred", :as => :login')})/
    assert_file "config/routes.rb", /(#{Regexp.escape('match "/auth/failure" => "sessions#failure"')})/

    assert_file "app/controllers/sessions_controller.rb" do |controller|
      assert_instance_method :create, controller
      assert_instance_method :destroy, controller
      assert_instance_method :failure, controller
      assert_instance_method :info, controller
    end

    assert_file "app/controllers/application_controller.rb" do |controller|
      assert_instance_method :current_user, controller
      assert_instance_method :set_state, controller
      assert_instance_method :authenticate, controller
      assert_instance_method :dailycred, controller
    end

    assert_file "app/helpers/application_helper.rb" do |helper|
      assert_instance_method :connect_path, helper
    end

    assert_file "app/models/user.rb" do |model|
      # assert_true model.include? "attr_accessible :email, :username, :created, :verified, :admin, :referred_by, :referred, :facebook, :tags, :provider, :uid, :token"
      assert_class_method :find_or_create_with_omniauth, model
      assert_true model.include? "serialize :facebook, Hash"
      assert_true model.include? "serialize :tags, Array"
      assert_true model.include? "serialize :referred, Array"
      assert_true model.include? "serialize :twitter, Hash"
      assert_true model.include? "serialize :google, Hash"
      assert_true model.include? "serialize :github, Hash"
    end

    assert_migration "db/migrate/create_users.rb" do |migration|
      assert_true migration.include? ":twitter"
      assert_true migration.include? ":github"
      assert_true migration.include? ":google"
    end
  end

  def assert_credentials client_id, client_secret
    assert_file "config/initializers/omniauth.rb" do |config|
      assert_true config.include? "Rails.configuration.DAILYCRED_CLIENT_ID = \"#{client_id}\""
      assert_true config.include? "Rails.configuration.DAILYCRED_SECRET_KEY = \"#{client_secret}\""
    end
  end

end