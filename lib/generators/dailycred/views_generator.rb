require 'rails/generators'
module Dailycred
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/views/', __FILE__)

      def copy_views
        directory "dailycred", "app/views/dailycred"
      end
    end
  end
end