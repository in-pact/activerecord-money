# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-money/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-money"
  gem.version       = Activerecord::Money::VERSION
  gem.authors       = ["Vlad Verestiuc"]
  gem.email         = ["vlad.verestiuc@me.com"]
  gem.description   = %q{ActiveRecord wrapper for money gem}
  gem.summary       = %q{ActiveRecord wrapper for money gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_dependency 'activerecord'
  gem.add_dependency 'money'
end
