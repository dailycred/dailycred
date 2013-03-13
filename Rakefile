#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end

desc "run travis"
task :travis do
  ["rake spec","ruby test/test_helper.rb"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => :travis

desc 'docs'
task :docs do
  begin
    require 'rocco'
    require 'rocco/tasks'
    require 'fileutils'
    require 'maruku'
    Rocco::make 'docs/'
    FileUtils.cp_r "docs/lib/", "/Users/hank/java/dailycred/public/docs/ruby/", :verbose => true
    md = ""
    File.open("README.md", "r") do |infile|
      while (line = infile.gets)
        md += line
      end
    end
    doc = Maruku.new(md)
    File.open("/Users/hank/java/dailycred/app/views/tags/docs/rubyonrails.html", 'w') {|f| f.write doc.to_html}
  rescue LoadError
    warn "#$! -- rocco tasks not loaded."
    task :rocco
  end
end
