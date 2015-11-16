# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bigint_pk/version"

Gem::Specification.new do |s|
  s.name        = "rails-bigint-pk"
  s.version     = BigintPk::VERSION
  s.authors     = ["David J. Hamilton"]
  s.email       = ["github@hjdivad.com"]
  s.homepage    = "https://github.com/caboteria/rails-bigint-pk"
  s.summary     = %q{Easily use 64-bit primary keys in rails}
  s.description = %q{Easily use 64-bit primary keys in rails}

  s.rubyforge_project = "rails-bigint-pk"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activerecord", '~> 3.2.0'
  s.add_runtime_dependency "railties", '~> 3.2.0'

  s.add_development_dependency "rspec", '~> 2.14'
  s.add_development_dependency "travis", '~> 1.8'
  s.add_development_dependency "rails", '~> 3.2.0'
  s.add_development_dependency "mysql2", '~> 0.3.0'
  s.add_development_dependency "mysql", '~> 2.9.0'
  s.add_development_dependency "pg", '~> 0.11'
  s.add_development_dependency "sqlite3", '~> 1.3.6'
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "guard-ctags-bundler"
  s.add_development_dependency "rb-fsevent"
end
