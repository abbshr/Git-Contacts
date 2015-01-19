# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitcontacts/version'

Gem::Specification.new do |spec|
  spec.name          = "gitcontacts"
  spec.version       = Gitcontacts::VERSION
  spec.authors       = ["Ran"]
  spec.email         = ["abbshr@outlook.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"
  spec.add_runtime_dependency "gitdb"
  spec.add_runtime_dependency "redis-sinatra"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "thin"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
