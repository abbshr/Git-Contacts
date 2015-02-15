# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api/version'

Gem::Specification.new do |spec|
  spec.name          = "gc-restful-api"
  spec.version       = Api::VERSION
  spec.authors       = ["Ran"]
  spec.email         = ["abbshr@outlook.com"]
  spec.summary       = %q{Git-Contacts Restful API}
  spec.description   = %q{Git-Contacts Restful API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "gitcontacts", "~> 0.1.4"
  spec.add_runtime_dependency "sinatra", "~> 1.4.5"
  spec.add_runtime_dependency "thin", "~> 1.6.3"
  spec.add_runtime_dependency "sinatra-contrib", "~> 1.4.2"
  spec.add_runtime_dependency "moneta", "~> 0.8.0"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
