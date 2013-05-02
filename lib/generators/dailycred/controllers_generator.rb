require 'rails/generators'
module Dailycred
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/controllers/', __FILE__)

      def copy_controllers
        directory "dailycred", "app/controllers/dailycred"
      end
    end
  end
end