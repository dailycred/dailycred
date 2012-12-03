#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end

# desc 'docs'
#   begin
#     require 'rocco'
#     require 'rocco/tasks'
#     require 'fileutils'
#     require 'maruku'
#     Rocco::make 'docs/'
#     FileUtils.cp_r "docs/lib/", "/Users/hank/rails/dailycred/public/docs/ruby/", :verbose => true
#     md = ""
#     File.open("README.md", "r") do |infile|
#       while (line = infile.gets)
#         md += line
#       end
#     end
#     doc = Maruku.new(md)
#     File.open("/Users/hank/rails/dailycred/app/views/tags/ruby.html", 'w') {|f| f.write doc.to_html}
#   rescue LoadError
#     warn "#$! -- rocco tasks not loaded."
#     task :rocco
#   end
# end
