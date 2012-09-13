#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end

begin
  require 'rocco/tasks'
  require 'fileutils'
  Rocco::make 'docs/'
  FileUtils.cp_r "docs/lib/", "/Users/hank/rails/dailycred/public/docs/ruby/"
rescue LoadError
  warn "#$! -- rocco tasks not loaded."
  task :rocco
end
