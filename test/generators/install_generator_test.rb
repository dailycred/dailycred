require 'test_helper'
class InstallGeneratorTest < Rails::Generators::TestCase

  include Dailycred::GeneratorTestHelpers
  include Dailycred::GeneratorTest
  destination File.expand_path("../support/tmp/myproject", File.dirname(__FILE__))
  tests Dailycred::Generators::InstallGenerator

  test "install generator works with input" do
    test_generator ["aaa","bbb"]
    assert_credentials "aaa", "bbb"
  end

  test "install generator works without input" do
    test_generator
    assert_credentials "YOUR_CLIENT_ID", "YOUR_SECRET_KEY"
  end

  test "install generator works without bootstrap" do
    test_generator [], false
  end

  test "credentials work when skipping bootstrap" do
    test_generator ["aaa", "bbb"], true
    assert_credentials "aaa", "bbb"
  end

end