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
  s.description = <<-DESC
                    Rails-bigint-pk modifies Rails so that it uses
                    64-bit primary and foreign keys.  It works with
                    MySQL and PostgreSQL and has versions for Rails
                    3 and 4.
                    DESC
  s.licenses    = ['MIT']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # we might work with older rubies but this is the oldest one that we
  # test with
  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency "activerecord", '>= 4.0', '< 5'
  s.add_runtime_dependency "railties", '>= 4.0', '< 5'

  s.add_development_dependency "rspec", '~> 2.14'
  s.add_development_dependency "travis", '~> 1.8'
  s.add_development_dependency "rails", '~> 4.1'
  s.add_development_dependency "mysql2", '~> 0.3'
  s.add_development_dependency "mysql", '~> 2.9'
  s.add_development_dependency "pg", '~> 0.11'
  s.add_development_dependency "sqlite3", '~> 1.3'
  s.add_development_dependency "guard", '~>2.5'
  s.add_development_dependency "guard-rspec", '~> 4.2'
  s.add_development_dependency "guard-bundler", '~> 2.0'
  s.add_development_dependency "guard-ctags-bundler", '~> 1.0'
  s.add_development_dependency "rb-fsevent", '~> 0.9'
end
