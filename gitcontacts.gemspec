# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitcontacts/version'

Gem::Specification.new do |spec|
  spec.name          = "gitcontacts"
  spec.version       = GitContacts::VERSION
  spec.authors       = ["ran"]
  spec.email         = ["abbshr@outlook.com"]
  spec.summary       = %q{"balabala"}
  spec.description   = %q{"balabala"}
  spec.homepage      = "http://github.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis", "~> 3.2.0"
  spec.add_runtime_dependency "gitdb", "~> 0.1.3"
  spec.add_runtime_dependency "redis-objects", "~> 1.0.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
