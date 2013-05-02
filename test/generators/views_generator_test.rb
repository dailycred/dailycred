require 'test_helper'
class ControllersGeneratorTest < Rails::Generators::TestCase
  
  include Dailycred::GeneratorTestHelpers
  destination File.expand_path("../support/tmp/myproject", File.dirname(__FILE__))
  tests Dailycred::Generators::ViewsGenerator

  test "creates correct view files" do
    run_generator
    assert_file "app/views/dailycred/sessions/info.html.erb"
  end

end