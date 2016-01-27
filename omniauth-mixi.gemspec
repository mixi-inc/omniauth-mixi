# -*- coding: utf-8 -*-
require File.expand_path('../lib/omniauth-mixi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yoichiro Tanaka"]
  gem.email         = ["yoichiro@eisbahn.jp"]
  gem.description   = %q{OmniAuth strategy for mixi.}
  gem.summary       = %q{OmniAuth strategy for mixi.}
  gem.homepage      = "https://github.com/mixi-inc/omniauth-mixi"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-mixi"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Mixi::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.1'
end
