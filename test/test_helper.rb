require 'test/unit'
require 'rails/generators'
require 'fileutils'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./lib/dailycred/*.rb"].each {|file| require file }
Dir["./lib/generators/dailycred/*.rb"].each {|file| require file }
Dir["./test/support/*.rb"].each {|file| require file }
require 'generators/dailycred_generator'


