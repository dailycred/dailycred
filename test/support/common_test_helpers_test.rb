module Dailycred
  module GeneratorTestHelpers
    def self.included base
      base.setup :prepare_destination
      base.teardown :remove_files
    end

    def prepare_destination
      # Must set before requiring generator libs.
      tmp_root = File.dirname(__FILE__) + "/tmp"
      project_name = "myproject"
      app_root = File.join(tmp_root, project_name)
      @rails_root = app_root
      FileUtils.mkdir_p @rails_root
      Dir.mkdir("#{@rails_root}/config") unless File.exists?("#{@rails_root}/config")
      File.open("#{@rails_root}/config/routes.rb", 'w') do |f|
        f.puts "ActionController::Routing::Routes.draw do\n\nend"
      end
      Dir.mkdir("#{@rails_root}/app") unless File.exists?("#{@rails_root}/app")
      Dir.mkdir("#{@rails_root}/app/controllers") unless File.exists?("#{@rails_root}/app/controllers")
      File.open("#{@rails_root}/app/controllers/application_controller.rb", 'w') do |f|
        f.puts "class ApplicationController < ActionController::Base\n\nend"
      end
    end

    def remove_files
      FileUtils.rm_rf File.dirname(__FILE__) + "/tmp"
    end

    def assert_credentials client_id, client_secret
      assert_file "config/initializers/omniauth.rb" do |config|
        assert config.include? "Rails.configuration.DAILYCRED_CLIENT_ID = \"#{client_id}\""
        assert config.include? "Rails.configuration.DAILYCRED_SECRET_KEY = \"#{client_secret}\""
      end
    end

  end
end

module Dailycred
  module GeneratorTest
    def test_generator args=[], bootstrap=true
      unless bootstrap
        args += ["a", "b"] if args.empty?
        args << "--skip-bootstrap"
      end
      run_generator args
      assert_file "config/initializers/omniauth.rb" do |config|
        assert config.include? 'Rails.configuration.DAILYCRED_CLIENT_ID ='
        assert config.include? 'Rails.configuration.DAILYCRED_SECRET_KEY ='
      end

      if bootstrap
        assert_file "config/routes.rb", /(#{Regexp.escape("mount Dailycred::Engine => '/auth', :as => 'dailycred_engine'")})/

        assert_file "app/models/user.rb" do |model|
          assert model.include? "acts_as_dailycred"
        end

        assert_file "app/controllers/application_controller.rb" do |controller|
        end

        assert_migration "db/migrate/create_users.rb" do |migration|
        end
      else
        assert_no_file "app/models/user.rb"
        assert_no_migration "db/migrate/create_users.rb"
      end
    end
  end
end