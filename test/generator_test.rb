class GeneratorTest < Rails::Generators::TestCase
  tests DailycredGenerator
  destination File.expand_path("./tmp/myproject", File.dirname(__FILE__))

  setup :prepare_destination
  setup do
    p RAILS_ROOT
    Dir.mkdir("#{RAILS_ROOT}/config") unless File.exists?("#{RAILS_ROOT}/config")
    File.open("#{RAILS_ROOT}/config/routes.rb", 'w') do |f|
      f.puts "ActionController::Routing::Routes.draw do |map|\n\nend"
    end
    Dir.mkdir("#{RAILS_ROOT}/app") unless File.exists?("#{RAILS_ROOT}/app")
    Dir.mkdir("#{RAILS_ROOT}/app/controllers") unless File.exists?("#{RAILS_ROOT}/app/controllers")
    File.open("#{RAILS_ROOT}/app/controllers/application_controller.rb", 'w') do |f|
      f.puts "class ApplicationController < ActionController::Base\n\nend"
    end
    # require_relative './tmp/myproject/app/controllers/application_controller.rb'
  end

  teardown do
    FileUtils.rm_rf "#{RAILS_ROOT}/config"
    FileUtils.rm_rf "#{RAILS_ROOT}/app"
  end

  test "Assert all files are properly created" do
    p 'about to run generator'
    run_generator
    p 'ran generator'
    assert_file "config/initializers/omniauth.rb"
    assert_file "config/routes.rb", /(#{Regexp.escape('"match "/logout" => "sessions#destroy", :as => :logout"')})/
    assert_file "app/controllers/sessions_controller.rb" do |controller|
      assert_instance_method :create
      assert_instance_method :destroy
      assert_instance_method :failure
      assert_instance_method :info
    end
  end

end