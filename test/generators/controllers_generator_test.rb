require 'test_helper'
class ViewsGeneratorTest < Rails::Generators::TestCase
  
  include Dailycred::GeneratorTestHelpers
  destination File.expand_path("../support/tmp/myproject", File.dirname(__FILE__))
  tests Dailycred::Generators::ControllersGenerator

  test "creates correct controller files" do
    run_generator
    assert_file "app/controllers/dailycred/sessions_controller.rb"
  end

end