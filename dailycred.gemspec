# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-dailycred/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hank Stoever"]
  gem.email         = ["hstove@gmail.com"]
  gem.description   = %q{descript}
  gem.summary       = %q{summary}
  gem.homepage      = "https://www.dailycred.com"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dailycred"
  gem.require_paths = ["lib"]
  gem.version       = Omniauth::Dailycred::VERSION
end
