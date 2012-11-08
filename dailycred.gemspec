# -*- encoding: utf-8 -*-=
require File.expand_path('../lib/dailycred/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hank Stoever"]
  gem.email         = ["hstove@gmail.com"]
  gem.description   = %q{A Ruby on Rails engine for authentication with Dailycred.}
  gem.summary       = %q{}
  gem.homepage      = "https://www.dailycred.com"
  gem.add_dependency("omniauth")
  gem.add_dependency("omniauth-oauth2")


  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dailycred"
  gem.require_paths = ["lib"]
  gem.version       = Dailycred::VERSION
end
