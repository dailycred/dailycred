# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/generators/(.+)\.rb$})     { "test/generator_test.rb" }
  watch(%r{^test/.+_test\.rb$}) { "test/generator_test.rb" }
  watch('test/test_helper.rb')  { "test/generator_test.rb" }
end

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/support/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end


# guard 'cucumber' do
#   watch(%r{^features/.+\.feature$})
#   watch(%r{^features/generator/.+\.feature$})
#   watch(%r{^features/support/.+$})          { 'features' }
#   watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
# end
